import 'package:latlong2/latlong.dart';

class FieldBoundary {
  final String id;
  final String name;
  final List<LatLng> points;
  final bool isPivot;
  final LatLng? pivotCenter;
  final double? pivotRadiusMeters;

  const FieldBoundary({
    required this.id,
    required this.name,
    required this.points,
    this.isPivot = false,
    this.pivotCenter,
    this.pivotRadiusMeters,
  });

  Map<String, dynamic> toGeoJson() {
    if (isPivot && pivotCenter != null && pivotRadiusMeters != null) {
      // Represent pivot as polygon approximation if needed
    }
    return {
      'type': 'Polygon',
      'coordinates': [
        points
            .map((p) => [p.longitude, p.latitude])
            .toList(),
      ],
    };
  }
}
