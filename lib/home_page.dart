import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaghazsoti/pages/library.dart';
import 'package:kaghazsoti/pages/home.dart';
import 'package:kaghazsoti/pages/category.dart';
import 'package:kaghazsoti/pages/profile.dart';
import 'package:kaghazsoti/pages/search.dart';


class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
    throw UnimplementedError();
  }

}

class MyHomePageState extends State<MyHomePage>{
  int currentPage = 0;

  final List children = [
     Home(),
    Search(),
    Library(),
     Profile(),
    Category(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.children[this.currentPage],
      bottomNavigationBar:
      BottomNavigationBar(
        backgroundColor: Colors.red,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.black,),label: "خانه"),
          BottomNavigationBarItem(icon: Icon(Icons.search,color: Colors.black,),label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box,color: Colors.black,),label: "Plus"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,color: Colors.black,),label: "favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.account_box,color: Colors.black,),label: "profile"),
        ],
        onTap: changePage,
        currentIndex: currentPage,
      ),
    );
    throw UnimplementedError();
  }

  void changePage(int s) {
    setState(() {
      this.currentPage = s;
    });
  }

}
