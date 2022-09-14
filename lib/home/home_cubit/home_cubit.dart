import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/home/home_cubit/cubit_state.dart';
import 'package:google_maps/shared/flutter_toast/flutter_toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  HomeCubit() : super(InitStateHome());

  static HomeCubit get(context) => BlocProvider.of(context);

  // test Gps opened or closed and request permission
  bool gpsValue = false;
  Future isGps(context) async {
    gpsValue = await Geolocator.isLocationServiceEnabled();
    Geolocator.getServiceStatusStream().listen((event) {
      if (event == ServiceStatus.disabled) {
        gpsValue = false;
      } else if (event == ServiceStatus.enabled) {
        gpsValue = true;
      }
    });
    if (gpsValue) {
      getPosition(context);
    } else {
      showToast(txt: 'Open GPS', color: Colors.red[200]!);
    }
  }

  // permission Request
  permissionReq() async {
    LocationPermission? locationPermission;
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      print('Request');
      // emit(IsGpsStateSuccess());
    }
  }

  // If GPS off This is Start Target Value on Map ('Ganzour')
  double startLat = 30.680099;
  double startLong = 31.033560;

  //  Get Phone Position (latitude , longitude)
  Position? loc;
  var targetLat;
  var targetLong;
  getPosition(context) async {
    emit(GetPositionLoadingState());
    await Geolocator.getCurrentPosition().then((value) {
      loc = value;
      targetLat = loc!.latitude;
      targetLong = loc!.longitude;
      print("$targetLat + $targetLong");
      getPlaceInfo(positionvalue: value).then((value) {
        setMarker();
      });
      emit(GetPositionSuccessHomeState());
    }).catchError((error) {
      print('Error In Get Position ${error.toString()}');
      emit(GetPositionErrorState());
    });
  }

  // Set Marker On Place
  Set<Marker> myMarker = {};
  setMarker() {
    try {
      myMarker.add(
        Marker(
            draggable: true,
            onDragEnd: (LatLng latLng) {},
            markerId: MarkerId('1'),
            position: LatLng(loc!.latitude, loc!.longitude),
            infoWindow: InfoWindow(
              title: infoList[1].locality,
              snippet: infoList[1].street,
            )),
      );
      print('Set Marker');
      // emit(SetMarkerSuccessState());
    } catch (e) {
      print('Error In Set Mark ${e.toString()}');
      emit(SetMarkerErrorState());
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
}
