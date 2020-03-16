import 'package:codenewswordpressclient/pages/fetch_home_posts.dart';
import 'package:codenewswordpressclient/pages/single_post.dart';
import 'package:intl/intl.dart' as intl;
import 'package:codenewswordpressclient/colors/mycolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:codenewswordpressclient/api/fetch_posts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';









class postsBycat extends StatefulWidget {


  int id;
  String name;

  postsBycat(this.id, this.name);



  @override
  _postsBycatState createState() => _postsBycatState();
}






class _postsBycatState extends State<postsBycat> {







  final wp.WordPress wordPress = wp.WordPress(baseUrl: Baseurl().baseUrl);




  List<wp.Post> posts;




  Future<List<wp.Post>> fetchPosts() async  {
    var posts = wordPress.fetchPosts(


      postParams: wp.ParamsPostList(

        context: wp.WordPressContext.view,
        postStatus: wp.PostPageStatus.publish,

        orderBy: wp.PostOrderBy.id,
        order: wp.Order.desc,
        includeCategories: [widget.id],


      ),



      fetchAuthor: true,
      fetchFeaturedMedia: true,
      fetchComments: true,
      fetchCategories: true,
      fetchTags: true,
    );







    return posts;



  }



  PageController _pageController;


  @override
  void initState() {
    _pageController = PageController();
    super.initState();
    this.getPosts();

  }


  Future<String> getPosts() async {
    var res = await fetchPosts();
    setState(() {
      posts = res;
    });
    return "Success!";
  }


  var postperpage = 5;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    this.getPosts();
    if (mounted) setState(() {});

    _refreshController.refreshCompleted();

  }

  void _onLoading() async {


    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()


    if (posts.length <= postperpage) {
      _refreshController.loadFailed();
    } else {
      postperpage += 1;
    }

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: maincolors().maincolor));



    return Directionality(

      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: maincolors().sec_color,

        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          backgroundColor: maincolors().maincolor,

          title: Text(widget.name),

        ),






        body: ifels(),

      ),
    );



  }





  fadeimg(int index){


    return FadeInImage.assetNetwork(
      placeholder:'imgs/loadingimg.png' ,
      image: posts[index].featuredMedia.mediaDetails.sizes.medium.sourceUrl.toString(),fit: BoxFit.cover,width: double.infinity,height: double.infinity,

    );
  }


  Widget ifels(){


    if(posts == null || posts.length == null){



      return Container(

        height: MediaQuery.of(context).size.height,
        width:MediaQuery.of(context).size.width,

        padding: EdgeInsets.symmetric(horizontal: 10),


        decoration: BoxDecoration(

          color: maincolors().sec_color,


        ),

        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('imgs/loadfade'),fit: BoxFit.cover,),
          ],
        ),



      );


    }
    else{

      return  SmartRefresher(


        enablePullDown: true,
        enablePullUp: true,

        header: WaterDropHeader(
          waterDropColor: maincolors().maincolor,
          complete: Text("تم التحديث!"),
        ),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("لا يوجد المزيد");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("فشل تحميل الاخبار! حاول مجدداً");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("افلت لمشاهدة المزيد من الاخبار");
            } else {
              body = Text("لا توجد اخبار اخرى");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,



        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: posts == null ? 0 : postber (posts.length),
          itemBuilder: (context, index) {



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
                            width: 250,
                            alignment: Alignment.bottomRight,
                            child: RichText(
                              textAlign: TextAlign.right,
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
                                    margin: EdgeInsets.only(right: 5),
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


          },
        ),



      );


    }












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

    var formatter = new intl.DateFormat('y-M-d');
    String formatted = formatter.format(myDatetime);

    return formatted;
  }


  int postber (int li){

    if(li < 5 ){


      return li;


    }else{

      return postperpage;

    }




  }




}
