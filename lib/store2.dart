import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Tutorial',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  List data = [
    "Flutter Tutorial 1",
    "Flutter Tutorial 2",
    "Flutter Tutorial 3",
    "Flutter Tutorial 4",
    "Flutter Tutorial 5",

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Refresh Indicator"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            updateData();
          },
          child:ListView(
            children: List.generate(data.length, (index) =>
                Card(
                  child: Container(
                    alignment: Alignment.center,
                    child:Text(data[index]),
                  ),
                ),
            ),
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            scrollDirection: Axis.vertical,
            itemExtent: 50,
          ),
          color: Colors.white,
          backgroundColor: Colors.purple,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
        )
    );
  }
  void updateData(){

    new Timer.periodic(
        Duration(seconds: 1),
            (Timer timer){
          int i = data.length+1;
          data.add("Flutter Tutorial $i");
          timer.cancel();
          setState(() {

          });
        }
    );


  }
}