import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mzansibeats/Animations/transitions.dart';
import 'package:mzansibeats/custom_icons.dart';
import 'package:mzansibeats/models/SongsModel.dart';
import 'package:mzansibeats/models/ThemeModel.dart';
import 'package:mzansibeats/screens/Player.dart';
import 'package:provider/provider.dart';
import 'package:mzansibeats/util/utility.dart';

class ShowStatus extends StatelessWidget {
  SongsModel model;
  double height, width;
  BuildContext context;
  ThemeChanger themeChanger;
  ShowStatus(this.model, this.height, this.width, this.context);
  @override
  Widget build(BuildContext context) {
    themeChanger = Provider.of<ThemeChanger>(this.context);
    return showStatus();
  }

  showStatus() {
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
              model.currentState != null && model.currentSong != null
                  ? Navigator.push(context, Scale(page: PlayBackPage()))
                  : print("nothing happens");
            },
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 14.0, right: 5 , top: 3, bottom: 3),
                        child: Hero(
                            tag: model.currentSong != null
                                ? model.currentSong?.id
                                : 1,
                            child: model.currentSong?.albumArt != null
                                ? Image.file(
                                    getImage(model.currentSong),
                                    width: 50.0,
                                    height: 50.0,
                                  )
                                : Container(
                                    height: 30,
                                    width: 30,
                                    child: IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      // Box decoration takes a gradient
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          themeChanger.accentColor,
                                          Color(0xFF1976D2),
                                          Color(0xFF42A5F5),
                                        ],
                                      ),
                                    )))),
                    Container(
                      width: width * 0.75,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: model.currentSong != null
                            ? Text(
                                model.currentSong.title,
                                style: Theme.of(context).textTheme.display2,
                                maxLines: 1,
                              )
                            : Text(
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
                                model.currentState == PlayerState.STOPPED ||
                                model.currentSong == null
                            ? Icon(
                                CustomIcons.play,
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                                size: 20.0,
                              )
                            : Icon(
                                CustomIcons.pause,
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                                size: 20.0,
                              ),
                        onPressed: () {
                          if (model.currentState == PlayerState.PAUSED ||
                              model.currentState == PlayerState.STOPPED ||
                              model.currentState == null) {
                            model.currentState == null
                                ? model.playShuffle()
                                : model.play();
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
