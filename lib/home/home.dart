import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/app_cubit/app_cubit.dart';
import 'package:google_maps/app_cubit/app_states_cubit.dart';
import 'package:google_maps/home/home_cubit/home_cubit.dart';
import 'package:google_maps/home/home_cubit/cubit_state.dart';
import 'package:google_maps/shared/flutter_toast/flutter_toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BitmapDescriptor? customMarker;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('Google Maps'),
              // automaticallyImplyLeading: false,
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
            ),
            body: Stack(
              children: [
                ConditionalBuilder(
                    condition: cubit.gpsValue
                        ? state is GetPositionSuccessHomeState
                        : true,
                    fallback: (context) => LinearProgressIndicator(),
                    builder: (context) {
                      return BlocConsumer<AppCubit, AppCubitStates>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            var appCubit = AppCubit.get(context);
                            return Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: cubit.gpsValue == true
                                        ? LatLng(
                                            cubit.targetLat,
                                            cubit.targetLong,
                                          )
                                        : LatLng(
                                            cubit.startLat,
                                            cubit.startLong,
                                          ),
                                    zoom: appCubit.zoom,
                                  ),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    appCubit.controller = controller;
                                    // cubit.setMarker();
                                  },
                                  onTap: (LatLng latLng) {
                                    appCubit.mapMarkClick(latLng);
                                    if (appCubit.livePosition != null) {
                                      appCubit.streamLocationCancel();
                                    }
                                  },
                                  markers: appCubit.clickMarker,
                                  // polygons: myPolygon(),
                                  circles: appCubit.drawCircle(
                                    latLng: cubit.gpsValue == true
                                        ? LatLng(
                                            cubit.targetLat,
                                            cubit.targetLong,
                                          )
                                        : LatLng(
                                            cubit.startLat,
                                            cubit.startLong,
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 20),
                                  child: InkWell(
                                    onTap: () {
                                      if (cubit.gpsValue) {
                                        appCubit.streamLocation();
                                      } else {
                                        showToast(
                                            txt: 'Open GPS',
                                            color: Colors.redAccent);
                                      }
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            if (appCubit.livePosition != null)
                                              BoxShadow(
                                                color: Colors.white,
                                                blurStyle: BlurStyle.solid,
                                                blurRadius: 15,
                                              ),
                                            if (appCubit.livePosition != null)
                                              BoxShadow(
                                                color: Colors.red,
                                                blurStyle: BlurStyle.solid,
                                                blurRadius: 15,
                                              )
                                          ],
                                          color: Colors.blue,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.gps_fixed,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
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
  // getCustomImage() async {
  //   // change crouser GPS
  //   customMarker = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(size: Size(10, 10)), 'assets/images/car_logo2.png');
  // }

  // Set<Polygon> myPolygon() {
  //   // Draw traingle on map or any shap
  //   var polygonCoords = <LatLng>[];
  //   polygonCoords.add(LatLng(37.43296265331129, -122.08832357078792));
  //   polygonCoords.add(LatLng(37.43006265331129, -122.08832357078792));
  //   polygonCoords.add(LatLng(37.43006265331129, -122.08332357078792));
  //   polygonCoords.add(LatLng(37.43296265331129, -122.08832357078792));

  //   var polygonSet = Set<Polygon>();
  //   polygonSet.add(
  //     Polygon(
  //       polygonId: PolygonId('1'),
  //       points: polygonCoords,
  //       strokeColor: Colors.red,
  //       strokeWidth: 1,
  //     ),
  //   );
  //   return polygonSet;
  // }
}
