import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/direction_service.dart';
import '../services/search_service.dart';

class GoogleMapScreenDynamicRoute extends StatefulWidget {
  const GoogleMapScreenDynamicRoute({super.key});

  @override
  State<GoogleMapScreenDynamicRoute> createState() =>
      _GoogleMapScreenDynamicRouteState();
}

class _GoogleMapScreenDynamicRouteState
    extends State<GoogleMapScreenDynamicRoute> {
  GoogleMapController? mapController;
  LatLng? _initialPosition;
  LatLng? _destination;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> _routePoints = [];
  Timer? _movementTimer;
  int _currentRouteIndex = 0;
  StreamSubscription<Position>? _positionStreamSubscription;
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService =
  SearchService(apiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _movementTimer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _markers.add(Marker(
        markerId: const MarkerId('current_location'),
        position: _initialPosition!,
        infoWindow: const InfoWindow(title: 'Current Location'),
      ));
    });

    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _initialPosition!, zoom: 15.0),
        ),
      );
    }

    _startLocationTracking();
  }

  void _startLocationTracking() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      LatLng newPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        _markers.removeWhere((m) => m.markerId.value == 'current_location');
        _markers.add(Marker(
          markerId: const MarkerId('current_location'),
          position: newPosition,
          visible: true,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ));

        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: newPosition, zoom: 15.0),
            ),
          );
        }
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (_initialPosition != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _initialPosition!, zoom: 15.0),
        ),
      );
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _destination = position;
      _markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: _destination!,
        infoWindow: const InfoWindow(title: 'Destination'),
      ));
      _getDirections(_initialPosition!, _destination!);
    });
  }

  Future<void> _getDirections(LatLng start, LatLng end) async {
    final directions = await DirectionsService().getDirections(start, end);

    setState(() {
      _polylines.clear();
      _routePoints = directions;
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: _routePoints,
        color: Colors.blue,
        width: 4,
      ));
      _startRiderMovement(); // Start rider movement along the route
    });

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        _boundsFromLatLngList([start, end]),
        50,
      ),
    );
  }

  void _startRiderMovement() {
    if (_routePoints.isNotEmpty) {
      _currentRouteIndex = 0;

      _movementTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentRouteIndex < _routePoints.length - 1) {
          setState(() {
            _currentRouteIndex++;
            LatLng newPosition = _routePoints[_currentRouteIndex];

            _markers.removeWhere((m) => m.markerId.value == 'current_location');
            _markers.add(Marker(
              markerId: const MarkerId('current_location'),
              position: newPosition,
              infoWindow: const InfoWindow(title: 'Moving to Destination'),
            ));

            mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: newPosition, zoom: 15.0),
              ),
            );
          });
        } else {
          _movementTimer?.cancel();
          _onRiderArrived();
        }
      });
    }
  }

  void _onRiderArrived() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arrived!'),
        content: const Text('The rider has reached the destination.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Fix this line
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0 = list.first.latitude, x1 = list.first.latitude;
    double y0 = list.first.longitude, y1 = list.first.longitude;
    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(x0, y0),
      northeast: LatLng(x1, y1),
    );
  }

  Future<void> _onSuggestionSelected(String placeId) async {
    final placeDetails = await _searchService.getPlaceDetails(placeId);
    LatLng position = LatLng(placeDetails['lat'], placeDetails['lng']);

    setState(() {
      _destination = position;
      _markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: _destination!,
        infoWindow: const InfoWindow(title: 'Destination'),
      ));
      _getDirections(_initialPosition!, _destination!);
    });

    mapController!.animateCamera(CameraUpdate.newLatLngZoom(_destination!, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps - Rider Simulation'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search for a place',
                  border: OutlineInputBorder(),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await _searchService.getSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion['description']),
                );
              },
              onSuggestionSelected: (suggestion) {
                _onSuggestionSelected(suggestion['place_id']);
              },
            ),
          ),
          Expanded(
            child: _initialPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition!,
                zoom: 15.0,
              ),
              markers: _markers,
              polylines: _polylines,
              onTap: _onMapTapped,
              trafficEnabled: true, // Enable traffic layer
            ),
          ),
        ],
      ),
    );
  }
}
