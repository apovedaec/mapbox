import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({Key? key}) : super(key: key);

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  late MapboxMapController mapController;
  // ignore: prefer_const_constructors
  final center = LatLng(-0.086629, -78.479803);
  String selectedStyle = 'mapbox://styles/apovedaec/cknqn6f0f04tq17qwxqux25zo';
  final oscuroStyle = 'mapbox://styles/apovedaec/cknqn6f0f04tq17qwxqux25zo';
  final streetStyle = 'mapbox://styles/apovedaec/cknqnadmz04wy17pcmj29gu91';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      accessToken:
          'pk.eyJ1IjoiYXBvdmVkYWVjIiwiYSI6ImNrbnFnNDBvZjBkMHYydm15dGM5NzBhOTUifQ.i7C4ZrVmZ1E2l476Dmg3Bg',
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: center, zoom: 14),
    );
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", Uri.parse("https://via.placeholder.com/50"));
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController.addImage(name, response.bodyBytes);
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //ZoomIn
        FloatingActionButton(
            child: Icon(Icons.emoji_symbols),
            onPressed: () {
              mapController.addSymbol(SymbolOptions(
                  geometry: center,
                  textField: 'Montaña creada',
                  iconImage: 'attraction-15',
                  // iconImage: 'assetImage',
                  iconSize: 2,
                  textOffset: Offset(0, 1)));
            }),
        SizedBox(
          height: 5,
        ),
        //ZoomIn
        FloatingActionButton(
            child: Icon(Icons.zoom_in),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomIn());
            }),
        SizedBox(
          height: 5,
        ),
        //ZoomOut
        FloatingActionButton(
            child: Icon(Icons.zoom_out),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomOut());
            }),
        SizedBox(
          height: 5,
        ),
        //Cambiar estilo de mapa
        FloatingActionButton(
            child: Icon(Icons.add_to_home_screen),
            onPressed: () {
              if (selectedStyle == oscuroStyle) {
                selectedStyle = streetStyle;
              } else {
                selectedStyle = oscuroStyle;
              }
              _onStyleLoaded();
              setState(() {});
            })
      ],
    );
  }
}
