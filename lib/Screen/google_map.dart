import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;
  late Position currentPosition;
  LatLng _initialPosition =
      const LatLng(22.7749, -75 + .4194); // Default to San Francisco
  late String _currentAddress = '';
  final TextEditingController _addressController = TextEditingController();
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
      _initialPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _initialPosition,
        ),
      );
      _getAddressFromLatLng();
    });
  }

  void _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _initialPosition.latitude, _initialPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
        _addressController.text = _currentAddress;
      });
    } catch (e) {
      debugPrint('>>>>>>>>>>>>>>$e<<<<<<<<<<<<<<');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _initialPosition = position.target;
      _markers[0] = Marker(
        markerId: const MarkerId('currentLocation'),
        position: _initialPosition,
      );
    });
    _getAddressFromLatLng();
  }

  Future<List<String>> getSuggestions(String query) async {
    List<Location> locations = await locationFromAddress(query);
    return locations
        .map((location) => '${location.latitude}, ${location.longitude}')
        .toList();
  }

  void onSuggestionSelected(String suggestion) async {
    List<Location> locations = await locationFromAddress(suggestion);
    if (locations.isNotEmpty) {
      Location location = locations[0];
      mapController.animateCamera(CameraUpdate.newLatLng(
          LatLng(location.latitude, location.longitude)));
      setState(() {
        _initialPosition = LatLng(location.latitude, location.longitude);
        _markers[0] = Marker(
          markerId: const MarkerId('currentLocation'),
          position: _initialPosition,
        );
      });
      _getAddressFromLatLng();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Current Location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(_markers),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onCameraMove: _onCameraMove,
            ),
          ),
          if (_currentAddress.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Address: $_currentAddress',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
