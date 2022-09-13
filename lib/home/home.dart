import 'dart:collection';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/app_cubit/app_cubit.dart';
import 'package:google_maps/app_cubit/app_states_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BitmapDescriptor? customMarker;

  getCustomImage() async {
    // change crouser GPS
    customMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10, 10)), 'assets/images/car_logo2.png');
  }

  Set<Polygon> myPolygon() {
    // Draw traingle on map or any shap
    var polygonCoords = <LatLng>[];
    polygonCoords.add(LatLng(37.43296265331129, -122.08832357078792));
    polygonCoords.add(LatLng(37.43006265331129, -122.08832357078792));
    polygonCoords.add(LatLng(37.43006265331129, -122.08332357078792));
    polygonCoords.add(LatLng(37.43296265331129, -122.08832357078792));

    var polygonSet = Set<Polygon>();
    polygonSet.add(
      Polygon(
        polygonId: PolygonId('1'),
        points: polygonCoords,
        strokeColor: Colors.red,
        strokeWidth: 1,
      ),
    );
    return polygonSet;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            floatingActionButton: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: FloatingActionButton(
                  onPressed: () {
                    cubit.isGps(context);
                  },
                  child: Icon(
                    Icons.gps_fixed,
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              title: Text('Google Maps'),
              centerTitle: true,
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.gps_fixed))
              ],
            ),
            body: Stack(
              children: [
                ConditionalBuilder(
                    condition: state is GetPositionSuccessState,
                    fallback: (context) => LinearProgressIndicator(),
                    builder: (context) {
                      return GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              cubit.loc!.latitude,
                              cubit.loc!.longitude,
                            ),
                            zoom: 14,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            cubit.setMarker();
                          },
                          markers: cubit.myMarker,
                          // polygons: myPolygon(),
                          circles: cubit.drawCircle(),);
                    }),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Ibrahim Map',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          );
        });
  }
}
