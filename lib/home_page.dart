import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Marker> _marker = <Marker>[
    Marker(
        markerId: MarkerId("1"),
        position: LatLng(23.7100, 90.3563),
        infoWindow: InfoWindow(title: "My location")
    ),
  ];
  loadData(){
    getUserCurrentLocation().then((value) async{
      print("My current Location");
      print(value.latitude.toString() + " " + value.longitude.toString());

      _marker.add(
          Marker(
              markerId: MarkerId("8"),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: InfoWindow(title: "This is my current location")
          )
      );
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 4
      );
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {

      });
    });
  }
  Future<Position> getUserCurrentLocation() async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace) async{
      await Geolocator.requestPermission();
      print("Error" + error.toString());
    });
    return Geolocator.getCurrentPosition();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }


  static final CameraPosition _kCamPosition = CameraPosition(
      target: LatLng(23.7100, 90.3563),
      zoom: 14,
  );
  Completer<GoogleMapController> _mapController = Completer();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: GoogleMap(
          initialCameraPosition: _kCamPosition,
        zoomControlsEnabled: false,
        markers: Set<Marker>.of(_marker),
        onMapCreated: (GoogleMapController controller){
            _mapController.complete();
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async{
            getUserCurrentLocation().then((value) async{
              print("My current Location");
              print(value.latitude.toString() + " " + value.longitude.toString());

              _marker.add(
                Marker(
                  markerId: MarkerId("8"),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(title: "This is my current location"),
                )
              );
              CameraPosition cameraPosition = CameraPosition(
                  target: LatLng(value.latitude, value.longitude),
                  zoom: 14
              );
              final GoogleMapController controller = await _mapController.future;

              controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {

              });
            });
      },
        child: Icon(Icons.location_searching_rounded),
      ),
    ));
  }
}
