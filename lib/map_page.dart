import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatelessWidget {

  final double latitude;
  final double longitude;
  final _mapController = MapController();

  MapPage({this.latitude = 35.8, this.longitude = 51.4, Key? key})  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: LatLng(latitude, longitude),
                    zoom: 11,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                  ],
                ),
                Center(child: buildMarkerIcon(context)),
              ],
            ),
            flex: 12,
          ),
          Flexible(
            child: Material(
              color: Theme.of(context).primaryColorDark,
              child: InkWell(
                onTap: () => putPressed(context),
                child: Container(
                  child: Icon(Icons.check, color: Colors.white,),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  putPressed(BuildContext context) {
    double latitude = _mapController.center.latitude;
    double longitude = _mapController.center.longitude;
    Navigator.of(context).pop(
        {
        'lat' : latitude,
        'lng' : longitude,
      }
    );
  }

  Widget buildMarkerIcon(BuildContext context) {
    var size = 15.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
