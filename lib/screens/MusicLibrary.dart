import 'package:mzansibeats/Animations/transitions.dart';
import 'package:mzansibeats/Models/PlayListHelper.dart';
import 'package:mzansibeats/models/PlaylistRepo.dart';
import 'package:mzansibeats/models/ThemeModel.dart';
import 'package:mzansibeats/models/BookmarkModel.dart';
import 'package:mzansibeats/models/const.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mzansibeats/models/SongsModel.dart';
import 'package:mzansibeats/screens/ArtistsList.dart';
import 'package:mzansibeats/screens/Songs.dart';
import 'package:mzansibeats/screens/artists.dart';
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
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
                      ],
                  body: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[getLoading(model, context)],
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: showStatus(model, context),
                      )
                    ],
                  ))),
    );
  }

  getLoading(SongsModel model, BuildContext context) {
    if (model.songs.length == 0) {
      return Expanded(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    } else {
      return Expanded(
        child: ListView(
          children: [ Divider(color: Colors.grey,),
          ListTile(
            trailing:new Icon(Icons.arrow_forward ),
            onTap: () async {


            },
            title: Text(
              "Playlits",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Sans'),
            ),
          ),Divider(color: Colors.grey,),
          ListTile(
        trailing:new Icon(Icons.arrow_forward ),
        onTap: () async {
          Navigator.push(
              context,
              EnterExitRoute(
                  exitPage: Library(),
                  enterPage: ArtistsList()));
        },
        title: Text(
          "Artists",
          maxLines: 1,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Sans'),
        ),
      ),Divider(color: Colors.grey,),
          ListTile(
            trailing:new Icon(Icons.arrow_forward ),
            onTap: () async {

            },
            title: Text(
              "Albums",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Sans'),
            ),
          ),Divider(color: Colors.grey,),
          ListTile(
            trailing:new Icon(Icons.arrow_forward ),
            onTap: () async {
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: Library(),
                      enterPage: Songs()));
            },
            title: Text(
              "Songs",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Sans'),
            ),
          ),Divider(color: Colors.grey,)],
        ),
      );
    }
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

  showStatus(model, BuildContext context) {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).textTheme.headline4.color,
              ),
            )),
        height: height * 0.06,
        width: width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (context, pos) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, Scale(page: PlayBackPage()));
              },
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        color: Theme.of(context).textTheme.headline4.color,
                        icon: Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          Navigator.push(context, Scale(page: PlayBackPage()));
                        },
                      ),
                      Container(
                        width: width * 0.75,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: model.currentSong != null ? Text(
                            model.currentSong.title,
                            style: Theme.of(context).textTheme.display2,
                            maxLines: 1,
                          ) : Text(
                            "Nothing playing",
                            style: Theme.of(context).textTheme.display2,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: IconButton(
                          icon: model.currentState == PlayerState.PAUSED ||
                                  model.currentState == PlayerState.STOPPED || model.currentSong == null
                              ? Icon(
                                  CustomIcons.play,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .color,
                                  size: 20.0,
                                )
                              : Icon(
                                  CustomIcons.pause,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .color,
                                  size: 20.0,
                                ),
                          onPressed: () {
                            if (model.currentState == PlayerState.PAUSED ||
                                model.currentState == PlayerState.STOPPED || model.currentSong == null) {
                              model.currentSong != null ? model.play() : model.random_Song();
                            } else {
                              model.pause();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
}
