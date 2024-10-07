import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerModel {
  final String id;
  final LatLng position;
  final String title;
  final String snippet;

  MarkerModel({
    required this.id,
    required this.position,
    required this.title,
    required this.snippet,
  });
}
