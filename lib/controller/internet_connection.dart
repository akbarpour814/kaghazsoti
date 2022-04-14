import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin InternetConnection<T extends StatefulWidget> on State<T> {
  late ConnectivityResult connectionStatus;
  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();

    connectionStatus = ConnectivityResult.none;
    _connectivity = Connectivity();
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }
}