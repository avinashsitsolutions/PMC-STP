import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tankerpcmc/builder/constants.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';

class MapRoute extends StatefulWidget {
  const MapRoute(
      {super.key, required this.startlocation, required this.endlocation});
  final LatLng startlocation;
  final LatLng endlocation;
  @override
  State<MapRoute> createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> polylineCoordinates = [];
  void getPloyPoints() async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          PointLatLng(
              widget.startlocation.latitude, widget.startlocation.longitude),
          PointLatLng(
              widget.endlocation.latitude, widget.endlocation.longitude));
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        setState(() {});
      } else {
        print("No polyline points found.");
      }
    } catch (e) {
      print("Error fetching polyline points: $e");
    }
  }

  MapType _currentMapType = MapType.normal;
  @override
  void initState() {
    getPloyPoints();
    print(polylineCoordinates);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.map_sharp),
        onPressed: () {
          setState(() {
            if (_currentMapType == MapType.satellite) {
              _currentMapType = MapType.normal;
            } else if (_currentMapType == MapType.normal) {
              _currentMapType = MapType.satellite;
            }
          });
        },
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          if (details.delta.dy < 0) {
            // scrolling up
            _controller.future.then((controller) {
              controller.animateCamera(
                CameraUpdate.zoomIn(),
              );
            });
          } else if (details.delta.dy > 0) {
            // scrolling down
            _controller.future.then((controller) {
              controller.animateCamera(
                CameraUpdate.zoomOut(),
              );
            });
          }
        },
        child: GoogleMap(
          indoorViewEnabled: false,
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          trafficEnabled: false,
          // minMaxZoomPreference: const MinMaxZoomPreference(10, 19),
          initialCameraPosition:
              CameraPosition(target: widget.startlocation, zoom: 12),
          markers: {
            Marker(
                markerId: const MarkerId("Source"),
                position: widget.startlocation),
            Marker(
                markerId: const MarkerId("Destination"),
                position: widget.endlocation)
          },
          polylines: {
            Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCoordinates,
                color: Colors.blue,
                width: 5,
                geodesic: true,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                jointType: JointType.mitered)
          },
          gestureRecognizers: Set()
            ..add(Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer()))
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
            ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
            ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),
          mapType: _currentMapType,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
