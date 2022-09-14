import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/app_cubit/app_cubit.dart';
import 'package:google_maps/home/home.dart';
import 'package:google_maps/home/home_cubit/cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()
            ..isGps(context)
            ..permissionReq(),
        ),
        BlocProvider(
          create: (context) => AppCubit(),
        )
      ],
      child: MaterialApp(
        home: Home(),
      ),
    );
  }
}
