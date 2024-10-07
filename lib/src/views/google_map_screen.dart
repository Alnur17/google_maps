import 'package:flutter/material.dart';
import 'package:google_maps/src/utils/polygon_util.dart';
import 'package:google_maps/src/utils/polyline_util.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/map_utils.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? mapController;
  final LatLng _initialPosition =
      const LatLng(23.843473652661974, 90.40292519999998);
  Set<Marker> _markers = {};
  Set<Polyline> _polyline = {};
  Set<Polygon> _polygon = {};

  @override
  void initState() {
    super.initState();
    _markers = getMarkers();
    _polyline = getPolyline();
    _polygon = getPolygons();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 15.0,
        ),
        markers: _markers,
        polylines: _polyline,
        polygons: _polygon,
      ),
    );
  }
}
