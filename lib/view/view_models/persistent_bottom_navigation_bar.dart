import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:takfood_seller/view/view_models/player_bottom_navigation_bar.dart';

import '../pages/category_page/category_page.dart';
import '../pages/home_page/home_page.dart';
import '../pages/library_page/library_page.dart';
import '../pages/profile_page/profile_page.dart';
import '../pages/search_page/search_page.dart';

class PersistentBottomNavigationBar extends StatefulWidget {
  const PersistentBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<PersistentBottomNavigationBar> createState() => _PersistentBottomNavigationBarState();
}

class _PersistentBottomNavigationBarState extends State<PersistentBottomNavigationBar> {
  late PersistentTabController _persistentTabController;
  late List<Widget> _pages;

  @override
  void initState() {
    _persistentTabController = PersistentTabController(initialIndex: 2);
    _pages = const [
      MyLibraryPage(),
      CategoryPage(),
      HomePage(),
      SearchPage(),
      ProfilePage(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _persistentTabController,
      screens: _pages,
      items: _items(),
      navBarStyle: NavBarStyle.style18,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
    );
  }

  List<PersistentBottomNavBarItem> _items() {
    Color _activeColorSecondary = Theme.of(context).primaryColor;
    Color _inactiveColorPrimary = Colors.grey;

    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Ionicons.library_outline),
        title: 'کتابخانه من',
        activeColorSecondary: _activeColorSecondary,
        inactiveColorPrimary: _inactiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Ionicons.albums_outline),
        title: 'دسته بندی',
        activeColorSecondary: _activeColorSecondary,
        inactiveColorPrimary: _inactiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Ionicons.home_outline),
        title: 'خانه',
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: _inactiveColorPrimary,
        activeColorPrimary: const Color(0xFF005C6B),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Ionicons.search_outline),
        title: 'جست و جو',
        activeColorSecondary: _activeColorSecondary,
        inactiveColorPrimary: _inactiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Ionicons.person_outline),
        title: 'نمایه من',
        activeColorSecondary: _activeColorSecondary,
        inactiveColorPrimary: _inactiveColorPrimary,
      ),
    ];
  }
}
