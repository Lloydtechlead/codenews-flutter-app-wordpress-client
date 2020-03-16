import 'dart:ui';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:codenewswordpressclient/colors/mycolors.dart';
import 'package:codenewswordpressclient/icons/Myiconsfile.dart';
import 'package:codenewswordpressclient/pages/categories.dart';
import 'package:codenewswordpressclient/pages/fetch_home_posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}





class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
    this.getPosts();
    this.getCat();

  }






  Future<String> getCat() async {
    var resCat = await fetchCategories();
    setState(() {
      cat = resCat;
    });
    return "Success!";
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarColor: Colors.white
        ));


    return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0.0,
            leading: Builder(
              builder: (BuildContext context) {

                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );},
            ),
            title: Image.asset('imgs/logo.png', fit: BoxFit.cover),
          ),
          drawer: Drawer(

            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Image(image: AssetImage('imgs/logo.png'),),
                  decoration: BoxDecoration(
                    color: Colors.white,


                  ),
                ),
                ListTile(
                  title: Text('about us', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                  onTap: () {
                   // do somthing

                  },
                ),

              ],
            ),
          ),
          bottomNavigationBar: BottomNavyBar(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
              _pageController.jumpToPage(index);
            },
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                activeColor: maincolors().maincolor,
                title: Text('last news'),
                icon: Icon(MyIcons.Home),
              ),
              BottomNavyBarItem(
                  activeColor: maincolors().maincolor,
                  title: Text('categories'),
                  icon: Icon(MyIcons.menu)),
            ],
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: maincolors().sec_color,
                ),
                child: SafeArea(
                  child: ifels(),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: maincolors().sec_color,
                ),
                child: SafeArea(
                  child: ListView.builder(
                    itemCount: cat == null ? 0 : cat.length,
                    itemBuilder: (BuildContext context, int index) {
                      return fetch_cat(context,index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget ifels(){


    if(posts == null || posts.length == null){



      return SingleChildScrollView(
        child: Container(


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
          itemCount: posts == null ? 0 : postperpage,
          itemBuilder: (BuildContext context, int index) {
            return buildPost(context, index);
          },
        ),


      );


    }












  }


}


