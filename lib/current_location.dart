import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition =  CameraPosition(target: LatLng(23.7100, 90.3563), zoom: 14);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: GoogleMap(
              initialCameraPosition: initialCameraPosition,
            markers: markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller){
                googleMapController = controller;
            },
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () async{
                Position position = await _determinePosition();

                googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 14)));

                markers.clear();

                markers.add(Marker(markerId: MarkerId("Current location"), position: LatLng(position.latitude, position.longitude), ),);

                setState(() {

                });
              },
            child: Icon(Icons.location_searching_rounded),
          ),
        )
    );
  }
  Future<Position> _determinePosition () async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return Future.error("Location services are disabled");
    }

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied){
        return Future.error("Location permission denied");
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error("Location permission are permanently denied");
    }

    Position position = await Geolocator.getCurrentPosition();
    print("Latitude: "+position.latitude.toString());
    print("Longitude: "+position.longitude.toString());

    return position;

  }
}
