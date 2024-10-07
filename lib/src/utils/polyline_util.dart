import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/polyline_model.dart';


Set<Polyline> getPolyline() {
  List<PolylineModel> polylineData = [
    PolylineModel(
      id: 'polyline1',
      points: [
        const LatLng(23.843473652661974, 90.40292519999998),
        const LatLng(23.733193700000093, 90.38376640000013),
      ],
      width: 4,
      color: const Color(0xFF00FF00),
    ),
    PolylineModel(
      id: 'polyline2',
      points: [
        const LatLng(23.733193700000093, 90.38376640000013),
        const LatLng(23.868025377350026, 90.30901388782178),
      ],
      width: 4,
      color: Colors.blue,  
    ),
  ];

  Set<Polyline> polylines = {};
  for (var polyline in polylineData) {
    polylines.add(
      Polyline(
        polylineId: PolylineId(polyline.id),
        points: polyline.points,
        width: polyline.width.toInt(),
        color: polyline.color,
        
      ),
    );
  }

  return polylines;
}
