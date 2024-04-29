import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EquipmentMap extends StatefulWidget {
  final double equipmentLatitude;
  final double equipmentLongitude;
  const EquipmentMap({
    required this.equipmentLatitude,
    required this.equipmentLongitude,
    super.key,
  });

  @override
  State<EquipmentMap> createState() => _EquipmentMapState();
}

class _EquipmentMapState extends State<EquipmentMap> {
  String googleAPiKey = "AIzaSyAwePplS2uCBh7P1wS7iNDoLV4qw05QaU4";
  Map<PolylineId, Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("Loading Map ..."),
                  ],
                ),
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          Position? _currentPosition = snapshot.data;
          return _currentPosition == null
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text(
                        "Loading your current location ...",
                      ),
                    ],
                  ),
                )
              : Scaffold(
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.startFloat,
                  floatingActionButton: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 120,
                        child: FloatingActionButton.extended(
                          heroTag: Object(),
                          onPressed: () async {
                            List<LatLng> polyPointsList =
                                await getPolylinePoints(
                              startingPostion: LatLng(
                                _currentPosition.latitude,
                                _currentPosition.longitude,
                              ),
                              targetPostion: LatLng(
                                widget.equipmentLatitude,
                                widget.equipmentLongitude,
                              ),
                              travelMode: TravelMode.walking,
                            );
                            addPolyLine(polyPointsList);
                          },
                          label: const Text(
                            "Walking \n route",
                            textAlign: TextAlign.center,
                          ),
                          icon: const Icon(Icons.directions_walk_rounded),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 120,
                        child: FloatingActionButton.extended(
                          heroTag: Object(),
                          onPressed: () async {
                            List<LatLng> polyPointsList =
                                await getPolylinePoints(
                              startingPostion: LatLng(
                                _currentPosition.latitude,
                                _currentPosition.longitude,
                              ),
                              targetPostion: LatLng(
                                widget.equipmentLatitude,
                                widget.equipmentLongitude,
                              ),
                              travelMode: TravelMode.driving,
                            );
                            addPolyLine(polyPointsList);
                          },
                          label: const Text(
                            "Driving \n route",
                            textAlign: TextAlign.center,
                          ),
                          icon: const Icon(Icons.directions_car_rounded),
                        ),
                      ),
                    ],
                  ),
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                  ),
                  body: GoogleMap(
                    mapType: MapType.hybrid,
                    rotateGesturesEnabled: true,
                    compassEnabled: true,
                    mapToolbarEnabled: false,
                    scrollGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.equipmentLatitude,
                        widget.equipmentLongitude,
                      ),
                      zoom: 9,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("equipment postion"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(300),
                        position: LatLng(
                          widget.equipmentLatitude,
                          widget.equipmentLongitude,
                        ),
                      ),
                      Marker(
                        markerId: const MarkerId("current position"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: LatLng(
                          _currentPosition.latitude,
                          _currentPosition.longitude,
                        ),
                        draggable: true,
                      ),
                    },
                    polylines: Set<Polyline>.of(polylines.values),
                  ),
                );
        }
        return const Scaffold(
          body: Center(
            child: Text(
              "Error loading map! retry later",
            ),
          ),
        );
      },
    );
  }

  Future<List<LatLng>> getPolylinePoints({
    required LatLng startingPostion,
    required LatLng targetPostion,
    required TravelMode travelMode,
  }) async {
    List<LatLng> polylinePointsList = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(
        startingPostion.latitude,
        startingPostion.longitude,
      ),
      PointLatLng(
        targetPostion.latitude,
        targetPostion.longitude,
      ),
      travelMode: travelMode,
    );
    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polylinePointsList.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        );
      }
      return polylinePointsList;
    } else {
      return [];
    }
  }

  void addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("rouet to equipment");
    Polyline polyline = Polyline(
      polylineId: id,
      color: const Color(0xff8ccff1),
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }
}
