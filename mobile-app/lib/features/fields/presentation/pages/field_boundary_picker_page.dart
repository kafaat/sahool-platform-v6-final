import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class FieldBoundaryPickerPage extends StatefulWidget {
  const FieldBoundaryPickerPage({super.key});

  @override
  State<FieldBoundaryPickerPage> createState() =>
      _FieldBoundaryPickerPageState();
}

class _FieldBoundaryPickerPageState extends State<FieldBoundaryPickerPage> {
  MaplibreMapController? _mapController;
  final List<LatLng> _points = [];
  double? _areaHaApprox; // مساحة تقريبية بالهكتار

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحديد حدود الحقل'),
        actions: [
          TextButton(
            onPressed: _points.length >= 3 ? _onDone : null,
            child: const Text(
              'تم',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          MaplibreMap(
            styleString:
                'https://api.maptiler.com/maps/hybrid/style.json?key=REPLACE_KEY',
            myLocationEnabled: true,
            myLocationRenderMode: MyLocationRenderMode.GPS,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onMapClick: (point, latLng) {
              setState(() {
                _points.add(latLng);
              });
              _updateGeometry();
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildHelperCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.touch_app_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _points.isEmpty
                        ? 'إلمس على الخريطة لرسم حدود الحقل (نقاط متتالية).'
                        : 'عدد النقاط: ${_points.length} — اضغط تم عند الانتهاء.',
                    style: textTheme.bodyMedium,
                  ),
                ),
                if (_points.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.undo),
                    onPressed: () {
                      setState(() {
                        if (_points.isNotEmpty) _points.removeLast();
                      });
                      _updateGeometry();
                    },
                  ),
              ],
            ),
            if (_areaHaApprox != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.stacked_bar_chart, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'مساحة تقريبية: ${_areaHaApprox!.toStringAsFixed(2)} هكتار',
                    style: textTheme.bodySmall
                        ?.copyWith(color: Colors.green[700]),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _updateGeometry() async {
    if (_mapController == null) return;
    await _mapController!.clearLines();
    await _mapController!.clearFills();

    if (_points.length < 2) {
      setState(() {
        _areaHaApprox = null;
      });
      return;
    }

    await _mapController!.addLine(
      LineOptions(
        geometry: _points,
        lineColor: '#00FF00',
        lineWidth: 2.0,
      ),
    );

    if (_points.length >= 3) {
      final closed = [..._points, _points.first];
      await _mapController!.addFill(
        FillOptions(
          geometry: [closed],
          fillColor: '#2200FF00',
          fillOutlineColor: '#00FF00',
        ),
      );

      final areaM2 = _computePolygonAreaMeters2(closed);
      setState(() {
        _areaHaApprox = areaM2 / 10000.0;
      });
    } else {
      setState(() {
        _areaHaApprox = null;
      });
    }
  }

  double _computePolygonAreaMeters2(List<LatLng> polygon) {
    if (polygon.length < 3) return 0.0;

    const earthRadius = 6378137.0;
    final points = polygon.map((p) {
      final lonRad = p.longitude * math.pi / 180.0;
      final latRad = p.latitude * math.pi / 180.0;
      final x = earthRadius * lonRad;
      final y = earthRadius *
          math.log(math.tan(math.pi / 4.0 + latRad / 2.0));
      return math.Point<double>(x, y);
    }).toList();

    double sum = 0.0;
    for (var i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      sum += (p1.x * p2.y) - (p2.x * p1.y);
    }
    return sum.abs() / 2.0;
  }

  void _onDone() {
    if (_points.length < 3) return;

    final coordinates = _points
        .map((p) => [p.longitude, p.latitude])
        .toList()
      ..add([_points.first.longitude, _points.first.latitude]);

    final geoJson = {
      'type': 'Polygon',
      'coordinates': [coordinates],
    };

    Navigator.of(context).pop<Map<String, dynamic>>({
      'polygon': geoJson,
      if (_areaHaApprox != null) 'areaHa': _areaHaApprox,
    });
  }
}