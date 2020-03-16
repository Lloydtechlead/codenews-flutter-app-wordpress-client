import 'package:codenewswordpressclient/colors/mycolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:codenewswordpressclient/api/fetch_posts.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:intl/intl.dart';
import 'package:html/parser.dart';
import 'category_posts.dart';

final wp.WordPress wordPress = wp.WordPress(baseUrl: Baseurl().baseUrl);




List<wp.Category> cat;
Future<List<wp.Category>> fetchCategories() async {
  var cat = wordPress.fetchCategories(
    params: wp.ParamsCategoryList(
      context: wp.WordPressContext.view,
      order: wp.Order.desc,
      hideEmpty: true,
    ),
  );
  return cat;
}

// posts[index].title.rendered
//

Widget fetch_cat(context,int index) {


  return Container(
    margin: EdgeInsets.only(top: 20),
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: RaisedButton(
        elevation: 0.0,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              Uncate(index),
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: maincolors().maincolor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            Container(
                color: maincolors().sec_color,
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text(cat[index].count.toString(), style: TextStyle(fontWeight: FontWeight.w700),))
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => postsBycat(

                  cat[index].id,
                  cat[index].name,



                ),
              ));
        }),
  );
}



String Uncate(int index) {
  if (cat[index].name == 'Uncategorized') {
    return "غير مصنف";
  } else {
    return cat[index].name;
  }
}
