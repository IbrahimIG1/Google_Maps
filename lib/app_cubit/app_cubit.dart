import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/app_cubit/app_states_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppCubit extends Cubit<AppCubitStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  double zoom = 14;
  GoogleMapController? controller;

  // Draw Circle on map
  Set<Circle> drawCircle({required LatLng latLng}) {
    Set<Circle> myCircle = {
      Circle(
          circleId: const CircleId('1'),
          center: latLng,
          radius: 400,
          strokeWidth: 1,
          fillColor: Colors.transparent,
          strokeColor: Colors.blue[300]!),
    };
    return myCircle;
  }

  Set<Marker> clickMarker = {};
  mapMarkClick(LatLng latLng) {
    clickMarker.clear();
    clickMarker.add(Marker(markerId: const MarkerId('1'), position: latLng));
    controller!.animateCamera(CameraUpdate.newLatLngZoom(latLng, 18));

    emit(MapMarkClicSuccessState());
  }

  StreamSubscription<Position>? livePosition;
  streamLocation() {
    livePosition = Geolocator.getPositionStream().listen((Position position) {
      LatLng latlong = LatLng(position.latitude, position.longitude);
      mapMarkClick(latlong);
    });
  }

  streamLocationCancel() {
    livePosition!.cancel();
    livePosition = null;
  }
}
