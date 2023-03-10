//------/dart and flutter packages
import 'package:flutter/material.dart';

//------/packages
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ionicons/ionicons.dart';

//------/view/pages/category_page
import '../../pages/category/category_page.dart';

//------/view/pages/home_page
import '../../pages/home/home_page.dart';

//------/view/pages/library_page
import '../../pages/library/library_page.dart';

//------/view/pages/profile_page
import '../../pages/profile/profile_page.dart';

//------/view/pages/search_page
import '../../pages/search/search_page.dart';

class PersistentBottomNavigationBar extends StatefulWidget {
  const PersistentBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<PersistentBottomNavigationBar> createState() =>
      _PersistentBottomNavigationBarState();
}

class _PersistentBottomNavigationBarState
    extends State<PersistentBottomNavigationBar> {
  late PersistentTabController _persistentTabController;
  late List<Widget> _pages;

  @override
  void initState() {
    _persistentTabController = PersistentTabController(initialIndex: 2);
    _pages = const [
      LibraryPage(),
      CategoryPage(),
      HomePage(),
      SearchPage(),
      ProfilePage(),
    ];

    super.initState();
  }

  //bool _secondTime = false;

  @override
  Widget build(BuildContext context) {
    /*
    WillPopScope(
      onWillPop: () async {
        if((_persistentTabController.index == 0)) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');

          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        } else {
          return true;
        }

        return false;
      },
    */
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
        title: '???????????????? ????',
        activeColorSecondary: _activeColorSecondary,
        inactiveColorPrimary: _inactiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Ionicons.albums_outline),
        title: '???????? ????????',
        activeColorSecondary: _activeColorSecondary,
        inactiveColorPrimary: _inactiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Ionicons.home_outline),
        title: '????????',
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: _inactiveColorPrimary,
        activeColorPrimary: const Color(0xFF005C6B),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Ionicons.search_outline),
        title: '?????? ?? ????',
        activeColorSecondary: _activeColorSecondary,
        inactiveColorPrimary: _inactiveColorPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Ionicons.person_outline),
        title: '?????????? ????',
        activeColorSecondary: _activeColorSecondary,
        inactiveColorPrimary: _inactiveColorPrimary,
      ),
    ];
  }
}
