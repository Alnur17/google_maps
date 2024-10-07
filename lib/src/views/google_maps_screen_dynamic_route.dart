import 'package:flutter/material.dart';
import 'package:google_maps/src/services/direction_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreenDynamicRoute extends StatefulWidget {
  const GoogleMapScreenDynamicRoute({super.key});

  @override
  State<GoogleMapScreenDynamicRoute> createState() => _GoogleMapScreenDynamicRouteState();
}

class _GoogleMapScreenDynamicRouteState extends State<GoogleMapScreenDynamicRoute> {
  GoogleMapController? mapController;
  LatLng? _initialPosition;
  LatLng? _destination;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Function to handle map taps and set the initial position or destination dynamically
  void _onMapTapped(LatLng position) {
    setState(() {
      if (_initialPosition == null) {
        // First click sets the initial location
        _initialPosition = position;
        _markers.add(Marker(
          markerId: const MarkerId('initial'),
          position: _initialPosition!,
          infoWindow: const InfoWindow(title: 'Initial Position'),
        ));
      } else if (_destination == null) {
        // Second click sets the destination
        _destination = position;
        _markers.add(Marker(
          markerId: const MarkerId('destination'),
          position: _destination!,
          infoWindow: const InfoWindow(title: 'Destination'),
        ));
        // Now get directions and draw polyline
        _getDirections();
      }
    });
  }

  // Fetch directions and draw the polyline on the map
  Future<void> _getDirections() async {
    if (_initialPosition != null && _destination != null) {
      final directions = await DirectionsService().getDirections(_initialPosition!, _destination!);

      setState(() {
        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          points: directions, // Set decoded points as polyline points
          color: Colors.blue,
          width: 4,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps - Route'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(23.843473652661974, 90.40292519999998), // Default to San Francisco
          zoom: 11.0,
        ),
        markers: _markers,
        polylines: _polylines, // Add the polyline
        onTap: _onMapTapped, // Listen for map taps
      ),
    );
  }
}
