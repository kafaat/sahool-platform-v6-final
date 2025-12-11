import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../../../../presentation/theme/app_colors.dart';

/// محرك خرائط NDVI الاحترافي - مستوى John Deere / Climate FieldView
class NdviMapEngine extends StatefulWidget {
  final String? ndviTileUrl;
  final double initialOpacity;
  final List<List<double>>? fieldPolygon;
  final LatLng? initialCenter;
  final double initialZoom;
  final Function(double)? onOpacityChanged;
  final Function(LatLng)? onMapTap;
  final Function(List<LatLng>)? onDrawComplete;
  final bool enableDrawing;
  final bool showControls;

  const NdviMapEngine({
    super.key,
    this.ndviTileUrl,
    this.initialOpacity = 0.85,
    this.fieldPolygon,
    this.initialCenter,
    this.initialZoom = 15,
    this.onOpacityChanged,
    this.onMapTap,
    this.onDrawComplete,
    this.enableDrawing = false,
    this.showControls = true,
  });

  @override
  State<NdviMapEngine> createState() => _NdviMapEngineState();
}

class _NdviMapEngineState extends State<NdviMapEngine> with TickerProviderStateMixin {
  MaplibreMapController? _controller;
  double _opacity = 0.85;
  bool _isLayerAdded = false;
  bool _isDrawing = false;
  List<LatLng> _drawnPoints = [];
  String _selectedLayer = 'satellite';
  bool _showNdviLayer = true;

  // Map Styles
  static const Map<String, String> _mapStyles = {
    'satellite': 'https://api.maptiler.com/maps/hybrid/style.json?key=get_your_key',
    'streets': 'https://demotiles.maplibre.org/style.json',
    'terrain': 'https://api.maptiler.com/maps/outdoor/style.json?key=get_your_key',
  };

  @override
  void initState() {
    super.initState();
    _opacity = widget.initialOpacity;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الخريطة الرئيسية
        MaplibreMap(
          onMapCreated: _onMapCreated,
          onMapClick: _onMapClick,
          styleString: _mapStyles[_selectedLayer] ?? _mapStyles['streets']!,
          initialCameraPosition: CameraPosition(
            target: widget.initialCenter ?? const LatLng(24.7136, 46.6753),
            zoom: widget.initialZoom,
          ),
          compassEnabled: true,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.None,
        ),

        // أدوات التحكم
        if (widget.showControls) ...[
          // شريط المعلومات العلوي
          _buildTopInfoBar(),
          
          // أدوات التكبير والتنقل
          _buildZoomControls(),
          
          // التحكم في الشفافية
          _buildOpacitySlider(),
          
          // أدوات الطبقات
          _buildLayerControls(),
          
          // أدوات الرسم
          if (widget.enableDrawing) _buildDrawingTools(),
          
          // مقياس المسافة
          _buildScaleBar(),
          
          // مؤشر الرسم
          if (_isDrawing) _buildDrawingIndicator(),
        ],
      ],
    );
  }

  Widget _buildTopInfoBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            // NDVI Value Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.getNdviColor(0.72),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'NDVI: 0.72',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Date Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 14),
                  SizedBox(width: 6),
                  Text(
                    '15 ديسمبر 2024',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Toggle NDVI Layer
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(
                  _showNdviLayer ? Icons.layers : Icons.layers_outlined,
                  color: _showNdviLayer ? AppColors.primary : Colors.grey,
                  size: 20,
                ),
                onPressed: _toggleNdviLayer,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      left: 16,
      bottom: 200,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildMapButton(
              icon: Icons.add,
              onTap: () => _controller?.animateCamera(CameraUpdate.zoomIn()),
            ),
            Container(height: 1, width: 30, color: Colors.grey.shade200),
            _buildMapButton(
              icon: Icons.remove,
              onTap: () => _controller?.animateCamera(CameraUpdate.zoomOut()),
            ),
            Container(height: 1, width: 30, color: Colors.grey.shade200),
            _buildMapButton(
              icon: Icons.my_location,
              onTap: _goToCurrentLocation,
            ),
            Container(height: 1, width: 30, color: Colors.grey.shade200),
            _buildMapButton(
              icon: Icons.crop_free,
              onTap: _fitToField,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 22, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildOpacitySlider() {
    return Positioned(
      right: 16,
      bottom: 200,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.opacity, size: 18, color: AppColors.primary),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: RotatedBox(
                quarterTurns: -1,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.neutral200,
                    thumbColor: AppColors.primary,
                  ),
                  child: Slider(
                    value: _opacity,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (value) {
                      setState(() => _opacity = value);
                      _updateNdviLayerOpacity(value);
                      widget.onOpacityChanged?.call(value);
                    },
                  ),
                ),
              ),
            ),
            Text(
              '${(_opacity * 100).round()}%',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerControls() {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).padding.top + 60,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildLayerButton('satellite', Icons.satellite_alt, 'قمر صناعي'),
            _buildLayerButton('streets', Icons.map, 'شوارع'),
            _buildLayerButton('terrain', Icons.terrain, 'تضاريس'),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerButton(String layerId, IconData icon, String tooltip) {
    final isSelected = _selectedLayer == layerId;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => _changeMapStyle(layerId),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySurface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawingTools() {
    return Positioned(
      left: 16,
      top: MediaQuery.of(context).padding.top + 60,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildDrawButton(Icons.edit, 'رسم حقل', () => _startDrawing()),
            _buildDrawButton(Icons.undo, 'تراجع', () => _undoLastPoint()),
            _buildDrawButton(Icons.check, 'إنهاء', () => _finishDrawing()),
            _buildDrawButton(Icons.delete, 'مسح', () => _clearDrawing()),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawButton(IconData icon, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildScaleBar() {
    return Positioned(
      left: 16,
      bottom: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            const Text('100 م', style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawingIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 120,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.touch_app, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'اضغط على الخريطة لإضافة نقاط (${_drawnPoints.length})',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Map Callbacks
  Future<void> _onMapCreated(MaplibreMapController controller) async {
    _controller = controller;
    
    // Add NDVI layer if URL provided
    if (widget.ndviTileUrl != null) {
      await _addNdviRasterLayer();
    }
    
    // Add field polygon if provided
    if (widget.fieldPolygon != null) {
      await _addFieldPolygon();
    }
  }

  void _onMapClick(Point<double> point, LatLng coordinates) {
    if (_isDrawing) {
      setState(() {
        _drawnPoints.add(coordinates);
      });
      _updateDrawnPolygon();
    }
    widget.onMapTap?.call(coordinates);
  }

  // Layer Management
  Future<void> _addNdviRasterLayer() async {
    if (_controller == null || widget.ndviTileUrl == null) return;

    try {
      await _controller!.addSource(
        'ndvi_source',
        RasterSourceProperties(
          tiles: [widget.ndviTileUrl!],
          tileSize: 256,
        ),
      );

      await _controller!.addLayer(
        'ndvi_source',
        'ndvi_layer',
        RasterLayerProperties(
          rasterOpacity: _opacity,
          rasterResampling: 'linear',
        ),
      );
      
      _isLayerAdded = true;
    } catch (e) {
      debugPrint('Error adding NDVI layer: $e');
    }
  }

  Future<void> _addFieldPolygon() async {
    if (_controller == null || widget.fieldPolygon == null) return;

    try {
      await _controller!.addSource(
        'field_source',
        GeojsonSourceProperties(
          data: {
            "type": "Feature",
            "geometry": {
              "type": "Polygon",
              "coordinates": [widget.fieldPolygon],
            }
          },
        ),
      );

      // Field boundary line
      await _controller!.addLayer(
        'field_source',
        'field_line_layer',
        const LineLayerProperties(
          lineColor: '#00A86B',
          lineWidth: 3,
          lineOpacity: 1,
        ),
      );

      // Field fill (semi-transparent)
      await _controller!.addFillLayer(
        'field_source',
        'field_fill_layer',
        const FillLayerProperties(
          fillColor: '#00A86B',
          fillOpacity: 0.1,
        ),
      );
    } catch (e) {
      debugPrint('Error adding field polygon: $e');
    }
  }

  Future<void> _updateNdviLayerOpacity(double opacity) async {
    if (_controller == null || !_isLayerAdded) return;
    
    try {
      await _controller!.setLayerProperties(
        'ndvi_layer',
        RasterLayerProperties(rasterOpacity: opacity),
      );
    } catch (e) {
      debugPrint('Error updating opacity: $e');
    }
  }

  void _toggleNdviLayer() {
    setState(() => _showNdviLayer = !_showNdviLayer);
    _updateNdviLayerOpacity(_showNdviLayer ? _opacity : 0);
  }

  void _changeMapStyle(String layerId) {
    setState(() => _selectedLayer = layerId);
    // Note: Changing style will reload the map
  }

  // Drawing Functions
  void _startDrawing() {
    setState(() {
      _isDrawing = true;
      _drawnPoints = [];
    });
  }

  void _undoLastPoint() {
    if (_drawnPoints.isNotEmpty) {
      setState(() {
        _drawnPoints.removeLast();
      });
      _updateDrawnPolygon();
    }
  }

  void _finishDrawing() {
    if (_drawnPoints.length >= 3) {
      widget.onDrawComplete?.call(_drawnPoints);
    }
    setState(() => _isDrawing = false);
  }

  void _clearDrawing() {
    setState(() {
      _drawnPoints = [];
      _isDrawing = false;
    });
    _removeDrawnPolygon();
  }

  Future<void> _updateDrawnPolygon() async {
    // Implementation for updating drawn polygon on map
  }

  Future<void> _removeDrawnPolygon() async {
    // Implementation for removing drawn polygon
  }

  // Navigation
  void _goToCurrentLocation() async {
    // Implementation for going to current location
  }

  void _fitToField() {
    if (widget.fieldPolygon != null && _controller != null) {
      // Implementation for fitting to field bounds
    }
  }
}
