

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/polygon_model.dart';

// Function to create and return polygons
Set<Polygon> getPolygons() {
  List<PolygonModel> polygonData = [
    PolygonModel(
      id: 'polygon1',
      points: const [
        LatLng(23.816051781514073, 90.3928839148335),  // San Francisco
        LatLng(23.821004860899606, 90.40626642279717),  // Point 2
        LatLng(23.80176575211557, 90.4266960444421),  // Point 3
        LatLng(23.79265478555598, 90.3992320787835),  // Point 4
      ],
      strokeWidth: 2,
      strokeColor: const Color(0xFF0000FF),  // Blue stroke
      fillColor: const Color(0x2200FF00),  // Translucent green fill
    ),
    PolygonModel(
      id: 'polygon2',
      points: const[
        LatLng(23.845959709513036, 90.40214088353217),  // Point 1
        LatLng(23.79742344325251, 90.46721402845694),  // Point 2
        LatLng(23.782660374882774, 90.40610483552872),  // Point 3
      ],
      strokeWidth: 2,
      strokeColor: const Color(0xFFFF0000),  // Red stroke
      fillColor: const Color(0x22FF0000),  // Translucent red fill
    ),
  ];

  Set<Polygon> polygons = {};
  for (var polygon in polygonData) {
    polygons.add(
      Polygon(
        polygonId: PolygonId(polygon.id),
        points: polygon.points,
        strokeWidth: polygon.strokeWidth.toInt(),
        strokeColor: polygon.strokeColor,
        fillColor: polygon.fillColor,
      ),
    );
  }

  return polygons;
}
