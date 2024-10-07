import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineModel {
  final String id;
  final List<LatLng> points;
  final double width;
  final Color color;

  PolylineModel({
    required this.id,
    required this.points,
    this.width = 5.0,
    this.color = const Color(0xFF0000FF), // Default blue color
  });
}
