import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/marker_model.dart';

// Function to create markers based on the list of MarkerModel
Set<Marker> getMarkers() {
  List<MarkerModel> markerData = [
    MarkerModel(
      id: 'marker1',
      position: const LatLng(23.843473652661974, 90.40292519999998),
      title: 'Hazrat Shahjalal International Airport',
      snippet: 'হযরত শাহ্জালাল আন্তর্জাতিক বিমানবন্দর, ঢাকা',
    ),
    MarkerModel(
      id: 'marker2',
      position: const LatLng(23.733193700000093, 90.38376640000013),
      title: 'Dhaka New Market',
      snippet:
          'Completed in 1954, this busy market complex \nhas a central triangular lawn & space for 440 shops.',
    ),
    MarkerModel(
      id: 'marker3',
      position: const LatLng(23.868025377350026, 90.30901388782178),
      title: 'BRAC University Residential Campus',
      snippet: 'ব্রাক ইউনির্ভাসিটি রেসিডেনসিয়াল ক্যাম্পাস',
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
