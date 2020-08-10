import 'package:mzansibeats/models/auth.dart';
import 'package:mzansibeats/screens/Bookmarks.dart';
import 'package:flutter/material.dart';
import 'package:expanding_bottom_bar/expanding_bottom_bar.dart';
import 'package:mzansibeats/screens/auth_screen.dart';
import 'package:provider/provider.dart';
import 'HomeScreen.dart';
import 'Settings.dart';
import 'MusicLibrary.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  var index = 1;
  var screens = [HomeScreen(), Library(), Bookmarks(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => auth.isAuth
          ? Scaffold(
              resizeToAvoidBottomInset: false,
              body: screens[index],
              bottomNavigationBar: ExpandingBottomBar(
                  animationDuration: Duration(milliseconds: 500),
                  backgroundColor: Theme.of(context).backgroundColor,
                  navBarHeight: 70,
                  items: [
                    ExpandingBottomBarItem(
                        icon: Icons.home,
                        text: "Home",
                        selectedColor: Colors.pinkAccent),
                    ExpandingBottomBarItem(
                        icon: Icons.music_note,
                        text: "Library",
                        selectedColor: Colors.deepPurpleAccent),
                    ExpandingBottomBarItem(
                        icon: Icons.favorite_border,
                        text: "Favourites",
                        selectedColor: Colors.red),
                    ExpandingBottomBarItem(
                        icon: Icons.settings,
                        text: "Settings",
                        selectedColor: Colors.blueAccent)
                  ],
                  selectedIndex: index,
                  onIndexChanged: (i) {
                    setState(() {
                      index = i;
                    });
                  }))
          : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                      ? new Center(
                          child: new Text('Loading...'),
                        )
                      : AuthScreen(),
            ),
    );
  }
}
