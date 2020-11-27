import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  Set<Marker> markers = new Set<Marker>();

  final databaseReference = Firestore.instance;

  Position _position;
  double myLatitude;
  double myLongitude;
  StreamSubscription<Position> _positionStream;

  //double lat = -19.9281712;
  //double long = -43.9630671;

  void initState() {
    super.initState();
    var locationOption =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positionStream = Geolocator()
        .getPositionStream(locationOption)
        .listen((Position position) {
      setState(() {
        _position = position;
        myLatitude = position.latitude;
        myLongitude = position.longitude;
        if (myLatitude != null && myLongitude != null) {
          getData(myLatitude ?? 0, myLongitude ?? 0);
        }
      });
    });
  }

  void getData(lat1, lat2) {
    print('Minha Latitude: ' + lat1.toString());
    print('Minha Longitude: ' + lat2.toString());
    databaseReference
        .collection("puc-units")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((units) => print('${units.data}}'));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    final Marker ppl = Marker(
        markerId: new MarkerId("ppl"),
        position: LatLng(-19.9332786, -43.9371484),
        infoWindow: InfoWindow(
            title: "PUC Praça da Liberdade", snippet: "Funcionários/BH"));

    final Marker coreu = Marker(
        markerId: new MarkerId("coreu"),
        position: LatLng(-19.9222935, -43.9908535),
        infoWindow: InfoWindow(
            title: "PUC Coração Eucarístico",
            snippet: "Coração Eucarístico/BH"));

    final Marker sg = Marker(
        markerId: new MarkerId("sg"),
        position: LatLng(-19.9024031, -43.997158),
        infoWindow:
            InfoWindow(title: "PUC São Gabriel", snippet: "São Gabriel/BH"));

    final Marker barreiro = Marker(
        markerId: new MarkerId("barreiro"),
        position: LatLng(-19.9389198, -44.032264),
        infoWindow: InfoWindow(title: "Puc Barreiro", snippet: "Barreiro/BH"));
    setState(() {
      markers.add(ppl);
      markers.add(coreu);
      markers.add(sg);
      markers.add(barreiro);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            //title: Text("Where go, PUC Minas"),
            title: Text('Where by PUCMINAS')),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          onCameraMove: (data) {
            //print(data);
          },
          onTap: (position) {
            //print(position);
          },
          initialCameraPosition: CameraPosition(
              target: LatLng(_position.latitude ?? 0, _position.longitude ?? 0),
              zoom: 18.0),
          markers: markers,
        ));
  }
}
