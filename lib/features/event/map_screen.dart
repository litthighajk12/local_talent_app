import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final String location;

  MapScreen({required this.location});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentPosition == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Map")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Nearby Event Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentPosition!,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId("user"),
            position: currentPosition!,
            infoWindow: InfoWindow(title: "Your Location"),
          ),
          Marker(
            markerId: MarkerId("event"),
            position: LatLng(
              currentPosition!.latitude + 0.01,
              currentPosition!.longitude + 0.01,
            ),
            infoWindow: InfoWindow(title: widget.location),
          )
        },
      ),
    );
  }
}