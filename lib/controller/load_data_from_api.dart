import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../view/view_models/custom_snack_bar.dart';
import 'custom_dio.dart';
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