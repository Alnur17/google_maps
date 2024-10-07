import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonModel {
  final String id;
  final List<LatLng> points;
  final double strokeWidth;
  final Color strokeColor;
  final Color fillColor;

  PolygonModel({
    required this.id,
    required this.points,
    this.strokeWidth = 3.0,
    this.strokeColor = const Color(0xFF000000), // Default black stroke
    this.fillColor = const Color(0x2200FF00),  // Default translucent green fill
  });
}
