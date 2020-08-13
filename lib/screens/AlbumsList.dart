import 'package:mzansibeats/Animations/transitions.dart';
import 'package:mzansibeats/Models/PlayListHelper.dart';
import 'package:mzansibeats/models/PlaylistRepo.dart';
import 'package:mzansibeats/models/ThemeModel.dart';
import 'package:mzansibeats/models/BookmarkModel.dart';
import 'package:mzansibeats/models/const.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mzansibeats/models/SongsModel.dart';
import 'package:mzansibeats/screens/albums.dart';
import 'package:mzansibeats/util/showStatus.dart';
import '../custom_icons.dart';
import 'package:provider/provider.dart';
import 'Player.dart';

double height, width;

class AlbumsList extends StatelessWidget {
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
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverSafeArea(
                          top: false,
                          sliver: SliverAppBar(
                            leading: Padding(
                                padding: EdgeInsets.only(
                                    top: height * 0.01, left: 5),
                                child: SizedBox(
                                  width: 42.0,
                                  height: 42.0,
                                  child: IconButton(
                                    iconSize: 35.0,
                                    icon: Icon(
                                      CustomIcons.arrow_circle_o_left,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                )),
                            automaticallyImplyLeading: false,
                            backgroundColor: Theme.of(context).backgroundColor,
                            expandedHeight: height * 0.11,
                            pinned: true,
                            flexibleSpace: Align(
                              alignment: Alignment.topCenter ,
                              child: Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Container(
                                  child: Stack(
                                    children: <Widget>[
                                      Text(
                                        "Albums",
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
                      ],
                  body: Stack(
                    children: <Widget>[
                      Album(model.db),
                      Align(
                        alignment: Alignment.bottomLeft,
                          child: ShowStatus(model, height, width, context)
                      )
                    ],
                  ))),
      onWillPop: () {},
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
