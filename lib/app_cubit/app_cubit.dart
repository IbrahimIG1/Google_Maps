import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/app_cubit/app_states_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppCubit extends Cubit<AppCubitStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  // test Gps opened or closed and request permission
  bool? gpsValue;
  Future isGps(context) async {
    gpsValue = await Geolocator.isLocationServiceEnabled();
    print('Gps Enabled');
  }

  permissionReq() async {
    LocationPermission? locationPermission;
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      print('Request');
      // emit(IsGpsStateSuccess());
    }
  }

  //  Get Phone Position (latitude , longitude)
  Position? loc;
  getPosition(context) async {
    emit(GetPositionLoadingState());
    await isGps(context);
    if (gpsValue! == false) {
      print('Open GPS');
    } else {
      await Geolocator.getCurrentPosition().then((value) {
        loc = value;
        print(loc);
        getPlaceInfo(positionvalue: value).then((value) {
          setMarker();
        });
        emit(GetPositionSuccessState());
      }).catchError((error) {
        print('Error In Get Position ${error.toString()}');
        emit(GetPositionErrorState());
      });
    }
  }

//  Get Place Information
  List<Placemark> infoList = [];
  Future getPlaceInfo({required Position positionvalue}) async {
    // emit(GetPlaceInfoLoadingState());
    await placemarkFromCoordinates(
            positionvalue.latitude, positionvalue.longitude)
        .then((value) {
      infoList = value;

      // emit(GetPlaceInfoSuccessState());
    }).catchError((error) {
      print('Error In get Place Info');
      emit(GetPlaceInfoErrorState());
    });
  }

  // Set Marker On Place
  var myMarker = HashSet<Marker>();
  setMarker() {
    try {
      myMarker.add(
        Marker(
            markerId: MarkerId('1'),
            position: LatLng(loc!.latitude, loc!.longitude),
            infoWindow: InfoWindow(
              title: infoList[1].locality,
              snippet: infoList[1].street,
            )),
      );
      // emit(SetMarkerSuccessState());
    } catch (e) {
      print('Error In Set Mark ${e.toString()}');
      emit(SetMarkerErrorState());
    }
  }

  // Draw Circle on map
  Set<Circle> drawCircle() {
    Set<Circle> myCircle = Set.from([
      Circle(
          circleId: CircleId('1'),
          center: LatLng(loc!.latitude, loc!.longitude),
          radius: 400,
          strokeWidth: 1,
          fillColor: Colors.transparent,
          strokeColor: Colors.blue[300]!),
    ]);
    return myCircle;
  }
}
