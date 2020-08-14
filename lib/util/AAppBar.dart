import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mzansibeats/custom_icons.dart';

class MzansiAppBar extends StatelessWidget {
  MzansiAppBar({this.title, this.isBack = false, this.height, this.width});
  final String title;
  final bool isBack;
  final double height, width;

  Widget build(BuildContext context) {

    return   SliverSafeArea(
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
                    title,
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
    );

  }
}
