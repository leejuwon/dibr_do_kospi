import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
//import 'package:webview_flutter/webview_flutter.dart';
//import "package:carousel_slider/carousel_slider.dart";
import "package:flutter_dibr_do_kospi/ad_manager.dart";
import 'package:firebase_admob/firebase_admob.dart';
import "package:flutter_dibr_do_kospi/screen/open_screen.dart";
import 'package:google_fonts/google_fonts.dart';
//import 'package:intl/intl.dart';

final investImgItems = [
  'images/pic_d.png',
  'images/pic_e.png',
  'images/pic_f.png',
];


var snpRate = -999.0;
var snpScore = -999.0;
var euroRate = -999.0;
var euroScore = -999.0;
var wtiRate = -999.0;
var wtiScore = -999.0;
var dubRate = -999.0;
var dubScore = -999.0;
var breRate = -999.0;
var breScore = -999.0;
var oilScore = -999.0;
var exRtScore = -999.0;
var exRtRate = -999.0;
var exRtBfRate = -999.0;
var exRtCrRate = -999.0;
var stdInvsPrice = 0.0;
var stdLvrsPrice = 0.0;
var strtInvsPrice = -999.0;
var strtLvrsPrice = -999.0;
var buyPrice1st = 0.0;
var buyPrice2nd = 0.0;
var sellDownPrice1st = 0.0;
var sellDownPrice2nd = 0.0;
var sellUpPrice1st = 0.0;
var sellUpPrice2nd = 0.0;
var wtiCnt = 0;
var dubCnt = 0;
var breCnt = 0;
var _index = 0;
var _pages = [OpenScreen(), Page2(), Page3()];
void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(MyApp());
}

//FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: //ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),

      ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: MyStartHomePage(),
    );
  }
}*/

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: "Do Kospi",
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.lime,
          accentColor: Colors.blue,
          textTheme: GoogleFonts.mcLarenTextTheme(
            Theme.of(context).textTheme,
          ),
      ),

      home: Container(
        child: Padding(
         child: OpenScreen(),
         padding: new EdgeInsets.only(bottom:48.0),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}



class ExpandableListView extends StatefulWidget {
  final String title;

  const ExpandableListView({Key key, this.title}) : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new Column(
        children: <Widget>[
          new Container(
            color: Colors.grey,
            padding: new EdgeInsets.symmetric(horizontal: 5.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new IconButton(
                    icon: new Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: new BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: new Center(
                        child: new Icon(
                          expandFlag
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        expandFlag = !expandFlag;
                      });
                    }),
                new Text(
                  widget.title,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ),
          new ExpandableContainer(
              expanded: expandFlag,
              child: new ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    decoration: new BoxDecoration(
                        border: new Border.all(width: 1.0, color: Colors.grey),
                        color: Colors.black),
                    child: new ListTile(
                      title: new Text(
                        "Cool $index",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      leading: new Icon(
                        Icons.local_pizza,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                itemCount: 5,
              ))
        ],
      ),
    );
  }
}

class ExpandableListViewSingle extends StatefulWidget {
  final String title;

  final String sInfo;

  final num stdRate;

  const ExpandableListViewSingle(
      {Key key, this.title, this.sInfo, this.stdRate})
      : super(key: key);

  @override
  _ExpandableListViewSingleState createState() =>
      new _ExpandableListViewSingleState();
}

class _ExpandableListViewSingleState extends State<ExpandableListViewSingle> {
  bool expandFlag = false;

  final myController = TextEditingController();

  //final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 2.0),
      child: new Column(
        children: <Widget>[
          new Container(
            color: Colors.white,
            padding: new EdgeInsets.symmetric(horizontal: 1.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new IconButton(
                    icon: new Container(
                      height: 30.0,
                      width: 50.0,
                      decoration: new BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.rectangle,
                      ),
                      child: new Center(
                        child: new Icon(
                          expandFlag
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        expandFlag = !expandFlag;
                      });
                    }),
                new Text(
                  widget.title,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.deepOrange),
                )
              ],
            ),
          ),
          new ExpandableContainer(
            expanded: expandFlag,
            child: TextField(
                controller: myController,
                textAlign: TextAlign.right,
                decoration: new InputDecoration(
                    labelText: "Enter ${widget.title} Rate"),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[0-9.-]"))
                ],
                onEditingComplete: () {
                  showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Rate 적용'),
                          content: Text('적용하시겠습니까? [${myController.text}]'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                if ('${widget.sInfo}' == 'snp') {
                                  snpScore =
                                      (double.parse(myController.text.trim()) /
                                          widget.stdRate *
                                          100)
                                          .roundToDouble() /
                                          100;

                                  snpRate =
                                      double.parse(myController.text.trim());

                                  print(snpScore);
                                } else if ('${widget.sInfo}' == 'euro') {
                                  euroScore =
                                      (double.parse(myController.text.trim()) /
                                          widget.stdRate *
                                          100)
                                          .roundToDouble() /
                                          100;

                                  euroRate =
                                      double.parse(myController.text.trim());

                                  print(euroScore);
                                } else if ('${widget.sInfo}' == 'wti') {
                                  wtiScore =
                                      (double.parse(myController.text.trim()) /
                                          widget.stdRate *
                                          100)
                                          .roundToDouble() /
                                          100;

                                  wtiRate =
                                      double.parse(myController.text.trim());

                                  if (wtiRate == 0.0) {
                                    wtiCnt = 0;
                                  } else {
                                    wtiCnt = 1;
                                  }

                                  if (dubScore != -999.0 &&
                                      breScore != -999.0) {
                                    oilScore =
                                        ((breScore + dubScore + wtiScore) /
                                            (wtiCnt + dubCnt + breCnt) *
                                            100)
                                            .roundToDouble() /
                                            100;
                                  }

                                  print(wtiScore);
                                } else if ('${widget.sInfo}' == 'dub') {
                                  dubScore =
                                      (double.parse(myController.text.trim()) /
                                          widget.stdRate *
                                          100)
                                          .roundToDouble() /
                                          100;

                                  dubRate =
                                      double.parse(myController.text.trim());

                                  if (dubRate == 0.0) {
                                    dubCnt = 0;
                                  } else {
                                    dubCnt = 1;
                                  }

                                  if (wtiScore != -999.0 &&
                                      breScore != -999.0) {
                                    oilScore =
                                        ((breScore + dubScore + wtiScore) /
                                            (wtiCnt + dubCnt + breCnt) *
                                            100)
                                            .roundToDouble() /
                                            100;
                                  }

                                  print(dubScore);
                                } else if ('${widget.sInfo}' == 'bre') {
                                  breScore =
                                      (double.parse(myController.text.trim()) /
                                          widget.stdRate *
                                          100)
                                          .roundToDouble() /
                                          100;

                                  breRate =
                                      double.parse(myController.text.trim());

                                  if (breRate == 0.0) {
                                    breCnt = 0;
                                  } else {
                                    breCnt = 1;
                                  }

                                  if (wtiScore != -999.0 &&
                                      dubScore != -999.0) {
                                    oilScore =
                                        ((breScore + dubScore + wtiScore) /
                                            (wtiCnt + dubCnt + breCnt) *
                                            100)
                                            .roundToDouble() /
                                            100;
                                  }

                                  print(breScore);
                                } else if ('${widget.sInfo}' == 'ber') {
                                  exRtBfRate =
                                      double.parse(myController.text.trim());

                                  if (exRtCrRate != -999.0) {
                                    exRtRate = ((exRtCrRate - exRtBfRate) /
                                        exRtBfRate *
                                        100 *
                                        100)
                                        .roundToDouble() /
                                        100;

                                    exRtScore = ((exRtCrRate - exRtBfRate) /
                                        exRtBfRate *
                                        100 /
                                        widget.stdRate *
                                        -100)
                                        .roundToDouble() /
                                        100;
                                  }

                                  print('exRtRate');

                                  print(exRtRate);

                                  print('exRtScore');

                                  print(exRtScore);
                                } else if ('${widget.sInfo}' == 'cer') {
                                  exRtCrRate =
                                      double.parse(myController.text.trim());

                                  if (exRtBfRate != -999.0) {
                                    exRtRate = ((exRtCrRate - exRtBfRate) /
                                        exRtBfRate *
                                        100 *
                                        100)
                                        .roundToDouble() /
                                        100;

                                    exRtScore = ((exRtCrRate - exRtBfRate) /
                                        exRtBfRate *
                                        100 /
                                        widget.stdRate *
                                        -100)
                                        .roundToDouble() /
                                        100;
                                  }

                                  print('exRtRate');

                                  print(exRtRate);

                                  print('exRtScore');

                                  print(exRtScore);
                                } else if ('${widget.sInfo}' == 'lvg') {
                                  strtLvrsPrice =
                                      double.parse(myController.text.trim());
                                } else if ('${widget.sInfo}' == 'ivs') {
                                  strtInvsPrice =
                                      double.parse(myController.text.trim());
                                }

                                Navigator.pop(context);

                                setState(() {
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      });
                }),
          )
        ],
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;

  final double collapsedHeight;

  final double expandedHeight;

  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 65.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return new AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: new Container(
        child: child,
        decoration: new BoxDecoration(
            border: new Border.all(width: 1.0, color: Colors.blue)),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("이용정보", style: TextStyle(fontSize: 40)));
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("내 정보", style: TextStyle(fontSize: 40)));
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
