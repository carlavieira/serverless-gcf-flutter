import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

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
  bool showAlert = false;

  // Coordenadas Coreu
  //double lat = -19.9222935;
  //double long = -43.9908535;

  // Coordenadas Barreiro
  //double lat = -19.976835;
  //double long = -44.0262124;

  // Coordenadas Praça da Liberdade
  //double lat = -19.9332786;
  //double long = -43.9371484;

  // Coordenadas São Gabriel
  //double lat = -19.8594055;
  //double long = -43.9189307;

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

  _checkItsClose(response) {
    if (response['itsClose'] && !showAlert) {
      _alert(response['pucname']);
      showAlert = true;
    }
  }

  Future<void> getData(lat1, lng1) async {
    Future fetchNearestPUC(latUnit, lngUnit, pucname) async {
      try {
        var url =
            'https://southamerica-east1-applied-shade-295522.cloudfunctions.net/find-puc/?' +
                'lat1=' +
                lat1.toString() +
                '&lng1=' +
                lng1.toString() +
                '&lat2=' +
                latUnit +
                '&lng2=' +
                lngUnit +
                '&pucname=' +
                pucname;
        http.Response response = await http.get(url);
        if (response.statusCode == 200) {
          return response.body;
        }
      } catch (exception) {
        print(exception.toString());
      }
    }

    // ignore: unused_local_variable
    var unityLat, unityLng, unityName, itsClose, response;

    databaseReference
        .collection("puc-units")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((units) async => {
            print(units.data),
            response = await (fetchNearestPUC(units.data['latitude'],
                units.data['longitude'], units.data['name'])),
            itsClose = jsonDecode(response)['itsClose'],
            _checkItsClose(jsonDecode(response))
          });
    });
  }

  Future<void> _alert(pucName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Próximo de uma PUC'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você se aproximou da PUC: ' + pucName),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                showAlert = false;
              },
            ),
          ],
        );
      },
    );
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
        appBar: AppBar(title: Text('Find me at PUC Minas')),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          onCameraMove: (data) {},
          myLocationEnabled: true,
          onTap: (position) {
            print(position);
          },
          initialCameraPosition: CameraPosition(
              target: LatLng(myLatitude ?? 0, myLongitude ?? 0), zoom: 18.0),
          markers: markers,
        ));
  }
}
