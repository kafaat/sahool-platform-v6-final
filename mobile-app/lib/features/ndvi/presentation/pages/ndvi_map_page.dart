import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

import '../../../../presentation/theme/app_colors.dart';
import '../bloc/ndvi_bloc.dart';
import '../widgets/ndvi_date_selector.dart';
import '../widgets/ndvi_legend.dart';

enum NdviBasemapType {
  mapLibre,
  google,
}

/// صفحة خريطة NDVI مع تكامل هجين:
/// MapLibre لطبقات NDVI tiles + Google Maps كخريطة خلفية اختيارية.
class NdviMapPage extends StatelessWidget {
  const NdviMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => const NdviBloc()..add(const NdviLoadRequested()),
      child: const _NdviMapView(),
    );
  }
}

class _NdviMapView extends StatefulWidget {
  const _NdviMapView();

  @override
  State<_NdviMapView> createState() => _NdviMapViewState();
}

class _NdviMapViewState extends State<_NdviMapView> {
  MaplibreMapController? _maplibreController;
  gmap.GoogleMapController? _googleController;

  NdviBasemapType _basemap = NdviBasemapType.mapLibre;
  String? _activeNdviLayerSceneId;

  static const _initialCenter = LatLng(15.5, 45.0); // تقريباً اليمن

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('خريطة NDVI'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // شريط اختيار التاريخ / المشهد
            BlocBuilder<NdviBloc, NdviState>(
              builder: (context, state) {
                return NdviDateSelector(
                  scenes: state.scenes,
                  selected: state.selected,
                  onTap: (scene) {
                    context.read<NdviBloc>().add(NdviDateSelected(scene));
                    _updateNdviScene(scene.id);
                  },
                );
              },
            ),
            const SizedBox(height: 4),
            // شريط اختيار نوع الخريطة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _BasemapToggle(
                current: _basemap,
                onChanged: (b) {
                  setState(() => _basemap = b);
                },
              ),
            ),
            const SizedBox(height: 8),
            // خريطة (MapLibre أو Google) + Legend سفلية
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<NdviBloc, NdviState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state.selected == null) {
                      return const Center(
                        child: Text('لا توجد بيانات NDVI متاحة حالياً.'),
                      );
                    }

                    final scene = state.selected!;
                    _activeNdviLayerSceneId ??= scene.id;

                    return Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _buildMap(scene.id),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const NdviLegend(),
                            Text(
                              'تاريخ: '
                              '${scene.date.day.toString().padLeft(2, '0')}/'
                              '${scene.date.month.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(String sceneId) {
    switch (_basemap) {
      case NdviBasemapType.mapLibre:
        return MaplibreMap(
          styleString: 'https://demotiles.maplibre.org/style.json',
          initialCameraPosition: const CameraPosition(
            target: _initialCenter,
            zoom: 6.5,
          ),
          myLocationEnabled: false,
          compassEnabled: true,
          rotateGesturesEnabled: true,
          onMapCreated: (controller) async {
            _maplibreController = controller;
            await _ensureNdviLayerAttached(sceneId: sceneId);
          },
        );
      case NdviBasemapType.google:
        return gmap.GoogleMap(
          mapType: gmap.MapType.hybrid,
          initialCameraPosition: const gmap.CameraPosition(
            target: gmap.LatLng(_initialCenter.latitude, _initialCenter.longitude),
            zoom: 6.5,
          ),
          myLocationEnabled: false,
          onMapCreated: (controller) {
            _googleController = controller;
            // ملاحظة: يمكن لاحقاً إضافة TileOverlay لطبقات NDVI فوق Google Maps
            // باستخدام gmap.TileOverlay + TileProvider.
          },
        );
    }
  }

  /// يضمن أن طبقة NDVI raster مضافة فوق خريطة MapLibre
  Future<void> _ensureNdviLayerAttached({required String sceneId}) async {
    if (_maplibreController == null) return;
    _activeNdviLayerSceneId = sceneId;

    const sourceId = 'ndvi-source';
    const layerId = 'ndvi-layer';

    // مسح المصدر والطبقة السابقة إن وُجدت
    try {
      await _maplibreController!.removeLayer(layerId);
    } catch (_) {}
    try {
      await _maplibreController!.removeSource(sourceId);
    } catch (_) {}

    // حالياً نستخدم نمط demo tiles.
    // يمكن استبدال هذا الرابط لاحقاً برابط backend الخاص بـ SAHOOL:
    // '${AppConfig.apiBaseUrl}/fields/{fieldId}/ndvi/$sceneId/tiles/{z}/{x}/{y}.png'
    const urlTemplate =
        'https://demotiles.maplibre.org/tiles/{z}/{x}/{y}.png';

    await _maplibreController!.addSource(
      sourceId,
      const RasterSourceProperties(
        tiles: [urlTemplate],
        tileSize: 256,
      ),
    );

    await _maplibreController!.addLayer(
      sourceId,
      layerId,
      const RasterLayerProperties(
        rasterOpacity: 0.85,
      ),
    );
  }

  /// تحديث طبقة NDVI عند تغيير المشهد (في وضع MapLibre)
  Future<void> _updateNdviScene(String sceneId) async {
    if (_basemap != NdviBasemapType.mapLibre) {
      // في وضع Google نكتفي بتحديث الحالة؛ طبقة NDVI في MapLibre فقط حالياً.
      setState(() {
        _activeNdviLayerSceneId = sceneId;
      });
      return;
    }
    if (_activeNdviLayerSceneId == sceneId) return;
    await _ensureNdviLayerAttached(sceneId: sceneId);
    setState(() {
      _activeNdviLayerSceneId = sceneId;
    });
  }
}

class _BasemapToggle extends StatelessWidget {
  final NdviBasemapType current;
  final ValueChanged<NdviBasemapType> onChanged;

  const _BasemapToggle({
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _toggleButton(
            context: context,
            label: 'MapLibre',
            selected: current == NdviBasemapType.mapLibre,
            onTap: () => onChanged(NdviBasemapType.mapLibre),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _toggleButton(
            context: context,
            label: 'Google Hybrid',
            selected: current == NdviBasemapType.google,
            onTap: () => onChanged(NdviBasemapType.google),
          ),
        ),
      ],
    );
  }

  Widget _toggleButton({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySurface : Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey[400]!,
            width: 1.2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? AppColors.primaryDark : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
