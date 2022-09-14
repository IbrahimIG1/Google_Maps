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
    Set<Circle> myCircle = Set.from([
      Circle(
          circleId: CircleId('1'),
          center: latLng,
          radius: 400,
          strokeWidth: 1,
          fillColor: Colors.transparent,
          strokeColor: Colors.blue[300]!),
    ]);
    return myCircle;
  }

  Set<Marker> clickMarker = {};
  mapMarkClick(LatLng latLng) {
    if(clickMarker.isEmpty)
    {
    clickMarker.add(Marker(markerId: MarkerId('1'), position: latLng));
    }else{
    clickMarker.remove(Marker(markerId: MarkerId('1')));
    clickMarker.add(Marker(markerId: MarkerId('1'), position: latLng));
    }
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
    livePosition!.pause();
  }
}
