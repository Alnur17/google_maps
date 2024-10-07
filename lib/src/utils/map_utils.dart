import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/marker_model.dart';

// Function to create markers based on the list of MarkerModel
Set<Marker> getMarkers() {
  List<MarkerModel> markerData = [
    MarkerModel(
      id: 'marker1',
      position: const LatLng(37.77483, -122.41942),
      title: 'San Francisco',
      snippet: 'A beautiful city',
    ),
    MarkerModel(
      id: 'marker2',
      position: const LatLng(34.05223, -118.24368),
      title: 'Los Angeles',
      snippet: 'Hollywood city',
    ),
  ];

  Set<Marker> markers = {};
  for (var marker in markerData) {
    markers.add(
      Marker(
        markerId: MarkerId(marker.id),
        position: marker.position,
        infoWindow: InfoWindow(
          title: marker.title,
          snippet: marker.snippet,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed), // Blue color marker
      ),
    );
  }

  return markers;
}
