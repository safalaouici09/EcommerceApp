import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({Key? key, required this.error}) : super(key: key);
  final FlutterErrorDetails error;
  @override
  Widget build(BuildContext context) {
    // String errorMessage = error.exceptionAsString();
    return Center(
      child: Text(
        // errorMessage,
        "",
        style: TextStyle(fontSize: 7),
      ),
    );
  }
}
