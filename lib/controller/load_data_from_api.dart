import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'custom_response.dart';

mixin LoadDataFromAPI<T extends StatefulWidget> on State<T> {
  late Response<dynamic> customDio;
  late CustomResponse customResponse;
  late bool dataIsLoading;

  @override
  void initState() {
    super.initState();

    dataIsLoading = true;
  }
}