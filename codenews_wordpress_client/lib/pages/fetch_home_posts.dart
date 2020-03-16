import 'package:codenewswordpressclient/api/fetch_posts.dart';
import 'package:codenewswordpressclient/colors/mycolors.dart';
import 'package:codenewswordpressclient/pages/single_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:intl/intl.dart';
import 'package:html/parser.dart';

final wp.WordPress wordPress = wp.WordPress(baseUrl: Baseurl().baseUrl);




List<wp.Post> posts;


Future<List<wp.Post>> fetchPosts() async  {
  var posts = wordPress.fetchPosts(
    postParams: wp.ParamsPostList(

      context: wp.WordPressContext.view,
      postStatus: wp.PostPageStatus.publish,
      orderBy: wp.PostOrderBy.date,
      order: wp.Order.desc,
    ),
    fetchAuthor: true,
    fetchFeaturedMedia: true,
    fetchComments: true,
    fetchCategories: true,
    fetchTags: false,


  );





  return posts;
}

Widget buildPost(context,int index) {




  if (index == 0) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Single_post(
              id: posts[index].id,
              title: posts[index].title.rendered.toString(),
              content: _parseHtmlString(posts[index].content.rendered.toString()),
              date: convert_time(posts[index].date).toString(),
              cat: posts[index].categories.first.name.toString(),
              image: posts[index].featuredMedia.sourceUrl.toString(),
              auther: posts[index].author.name.toString(),
              url: posts[index].link.toString(),
              avatar: posts[index].author.avatarUrls.s96.toString(),
            ),


          ),
        );
      },
      child: Container(
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  child: buildImage(index),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.9),
                        ],
                        stops: [
                          0.2,
                          0.7
                        ]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 10),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          posts[index].title.rendered,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Kufi',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: 22,
                                padding: EdgeInsets.only(left: 6, right: 6),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: maincolors().maincolor,
                                  ),
                                ),
                                child: Text(
                                  posts[index].categories.first.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: maincolors().maincolor,
                                  ),
                                ),
                              ),
                              Container(
                                height: 22,
                                margin: EdgeInsets.only(left: 5),
                                padding: EdgeInsets.only(left: 6, right: 6),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: maincolors().maincolor),
                                ),
                                child: Text(
                                  convert_time(posts[index].date),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: maincolors().maincolor,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  if (index == 3 || index == 6 || index == 10) {
    return GestureDetector(

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Single_post(
              id: posts[index].id,
              title: posts[index].title.rendered.toString(),
              content: _parseHtmlString(posts[index].content.rendered.toString()),
              date: convert_time(posts[index].date).toString(),
              cat: posts[index].categories.first.name.toString(),
              image: posts[index].featuredMedia.sourceUrl.toString(),
              auther: posts[index].author.name.toString(),
              avatar: posts[index].author.avatarUrls.s96.toString(),
            ),

          ),
        );
      },

      child: Container(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: buildImage(index),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 1, top: 10),
                          width: 150,
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,

                            text: TextSpan(
                                text: posts[index].title.rendered,
                                style: TextStyle(

                                  fontSize: 17,
                                  fontFamily: 'Kufi',
                                  color: maincolors().maincolor,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 10,
                          ),
                          width: 150,
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            text: TextSpan(
                                text: _parseHtmlString(
                                    posts[index].content.rendered),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kufi',
                                  color: Colors.black,
                                )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 22,
                                  padding: EdgeInsets.only(left: 6, right: 6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: maincolors().maincolor,
                                    ),
                                  ),
                                  child: Text(
                                    posts[index].categories.first.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: maincolors().maincolor,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 22,
                                  margin: EdgeInsets.only(left: 5),
                                  padding: EdgeInsets.only(left: 6, right: 6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: maincolors().maincolor,
                                    ),
                                  ),
                                  child: Text(
                                    convert_time(posts[index].date),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: maincolors().maincolor,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Single_post(
            id: posts[index].id,
            title: posts[index].title.rendered.toString(),
            content: _parseHtmlString(posts[index].content.rendered.toString()),
            date: convert_time(posts[index].date).toString(),
            cat: posts[index].categories.first.name.toString(),
            image: posts[index].featuredMedia.sourceUrl.toString(),
            auther: posts[index].author.name.toString(),
            avatar: posts[index].author.avatarUrls.s96.toString(),
          ),


        ),
      );
    },
    child: Container(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            height: 340,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: buildImage(index),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10, top: 10),

                  alignment: Alignment.bottomLeft,
                  child: RichText(
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    text: TextSpan(
                        text: posts[index].title.rendered,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Kufi',
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 22,
                          padding: EdgeInsets.only(left: 6, right: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Text(
                            posts[index].categories.first.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          height: 22,
                          margin: EdgeInsets.only(left: 5),
                          padding: EdgeInsets.only(left: 6, right: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Text(
                            convert_time(posts[index].date),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        )),
  );


}

fadeimg(int index){


  return FadeInImage.assetNetwork(
    placeholder:'imgs/loadingimg.png' ,
    image: posts[index].featuredMedia.mediaDetails.sizes.medium.sourceUrl.toString(),fit: BoxFit.cover,width: double.infinity,height: double.infinity,

  );
}




Widget buildImage(int index) {

  if (posts[index].featuredMedia.sourceUrl == null) {
    return Image( image: AssetImage('imgs/loadingimg.png'),) ;
  }
  return  fadeimg(index);
}

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}

String convert_time(String date) {
  DateTime myDatetime = DateTime.parse(date);

  var formatter = new DateFormat('y-M-d');
  String formatted = formatter.format(myDatetime);

  return formatted;
}



