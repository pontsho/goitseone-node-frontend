import 'package:flutter/cupertino.dart';
import 'package:mzansibeats/Animations/transitions.dart';
import 'package:mzansibeats/models/ThemeModel.dart';
import 'package:mzansibeats/models/BookmarkModel.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mzansibeats/models/SongsModel.dart';
import 'package:mzansibeats/screens/AlbumsList.dart';
import 'package:mzansibeats/screens/ArtistsList.dart';
import 'package:mzansibeats/screens/PlayLists.dart';
import 'package:mzansibeats/screens/Songs.dart';
import 'package:mzansibeats/util/showStatus.dart';
import '../custom_icons.dart';
import 'package:provider/provider.dart';
import 'Player.dart';

double height, width;

class Library extends StatelessWidget {
  TextEditingController editingController;

  SongsModel model;

  BookmarkModel b;

  ThemeChanger themeChanger;

  TextEditingController txt = TextEditingController();

  bool error = false;

  @override
  Widget build(BuildContext context) {
    model = Provider.of<SongsModel>(context);
    b = Provider.of<BookmarkModel>(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    themeChanger = Provider.of<ThemeChanger>(context);
    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).backgroundColor,
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                print("innerBoxIsScrolled $innerBoxIsScrolled");
                return [
                    SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                        backgroundColor: Theme.of(context).backgroundColor,
                        expandedHeight: height * 0.11,
                        pinned: true,
                        flexibleSpace: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 0.06),
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  Text(
                                    "Library",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ];},
              body: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[getLoading(model, context)],
                  ),
                  Align(
                    child: new FloatingActionButton(
                      onPressed: () => model.db.insertSongs(),
                      child: new Icon(CupertinoIcons.refresh),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueGrey,
                    ),
                    alignment: Alignment(0.9, 0.8),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ShowStatus(model, height, width, context),
                  )
                ],
              ))),
    );
  }

  getLoading(SongsModel model, BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            trailing: new Icon(CupertinoIcons.forward),
            onTap: () async {Navigator.push(
                context,
                EnterExitRoute(
                    exitPage: Library(), enterPage: PlayList()));
            },
            title: Text(
              "Playlits",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Sans'),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            trailing: new Icon(CupertinoIcons.forward),
            onTap: () async {
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: Library(), enterPage: ArtistsList()));
            },
            title: Text(
              "Artists",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Sans'),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            trailing: new Icon(CupertinoIcons.forward),
            onTap: () async {
              Navigator.push(context,
                  EnterExitRoute(exitPage: Library(), enterPage: AlbumsList()));
            },
            title: Text(
              "Albums",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Sans'),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            trailing: new Icon(CupertinoIcons.forward),
            onTap: () async {
              Navigator.push(context,
                  EnterExitRoute(exitPage: Library(), enterPage: Songs()));
            },
            title: Text(
              "Songs",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Sans'),
            ),
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  getImage(model, pos) {
    if (model.songs[pos].albumArt != null) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child:
              Image.file(File.fromUri(Uri.parse(model.songs[pos].albumArt))));
    } else {
      return Container(
          child: IconButton(
            onPressed: null,
            icon: Icon(
              Icons.music_note,
              color: Colors.white,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            // Box decoration takes a gradient
            gradient: LinearGradient(
              colors: <Color>[
                themeChanger.accentColor,
                Color(0xFF1976D2),
                Color(0xFF42A5F5),
              ],
            ),
          ));
    }
  }

  push(context) {
    Navigator.push(context, SlideRightRoute(page: PlayBackPage()));
  }

}
