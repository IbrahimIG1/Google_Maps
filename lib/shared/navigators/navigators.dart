import 'package:flutter/material.dart';

NavigateTo(context, route) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));

NavigateAndReplace(context, route) => Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context) => route));


