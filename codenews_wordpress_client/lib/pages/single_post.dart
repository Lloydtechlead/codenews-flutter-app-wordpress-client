import 'package:codenewswordpressclient/colors/mycolors.dart';
import 'package:codenewswordpressclient/icons/Myiconsfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:photo_view/photo_view.dart';

class Single_post extends StatelessWidget {
  final int id;

  final String title;

  final String date;

  final String cat;

  final String content;

  final String image;
  final String auther;
  final String url;
  final String avatar;

  Single_post(
      {Key key,
        @required this.id,
        this.title,
        this.content,
        this.date,
        this.cat,
        this.image,
        this.auther,
        this.url,
        this.avatar})
      : super(key: key);

  @override
  Widget build(context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: maincolors().sec_color));

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0.0,
          backgroundColor: maincolors().sec_color,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(
                  MyIcons.share__1_,
                  color: Colors.black,
                ),
                onPressed: title.isEmpty
                    ? null
                    : () {
                  final RenderBox box = context.findRenderObject();
                  Share.share(url,
                      subject: title,
                      sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
                },
              ),
            ),
          ],
          leading: IconButton(
              icon: Icon(
                MyIcons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  height: 300,
                  child: buildImage(image),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width : 40,
                        height: 40,

                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),

                            child: avatarimg(avatar)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 1),
                            height: 22,
                            padding: EdgeInsets.only(right: 6),
                            alignment: Alignment.center,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "By " + auther,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 22,
                                padding: EdgeInsets.only(right: 6),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "in " + cat,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                              Container(
                                height: 22,

                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "|",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                height: 22,

                                padding: EdgeInsets.only(left: 6, right: 6),
                                alignment: Alignment.center,
                                child: Text(
                                  "On " + date,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

fadeimg(image) {
  return FadeInImage.assetNetwork(
    placeholder: 'imgs/loadingimg.png',
    image: image,
    fit: BoxFit.cover,
  );
}

Widget buildImage(image) {
  if (image == null) {
    return Image(
      image: AssetImage('imgs/loadingimg.png'),
    );
  }
  return fadeimg(image);
}

Widget avatarimg(avatarimg) {
  if (avatarimg == null) {
    return Image(
      image: AssetImage('imgs/loadingimg.png'),
    );
  }
  return Image.network(
    avatarimg,
    fit: BoxFit.cover,
  );
}
