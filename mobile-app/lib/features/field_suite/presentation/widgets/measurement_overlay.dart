import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MeasurementOverlay extends StatelessWidget {
  final List<LatLng> points;

  const MeasurementOverlay({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();
    final distanceKm = _totalDistanceKm(points);
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'إجمالي المسافة: ${distanceKm.toStringAsFixed(2)} كم',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  double _totalDistanceKm(List<LatLng> pts) {
    if (pts.length < 2) return 0;
    const Distance d = Distance();
    double sum = 0;
    for (int i = 1; i < pts.length; i++) {
      sum += d.as(LengthUnit.Meter, pts[i - 1], pts[i]);
    }
    return sum / 1000.0;
  }
}
