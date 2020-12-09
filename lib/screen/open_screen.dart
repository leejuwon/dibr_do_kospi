import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/services.dart';
import "package:flutter_dibr_do_kospi/ad_manager.dart";
import "package:flutter_dibr_do_kospi/screen/contents_screen.dart";
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class OpenScreen extends StatefulWidget {
  @override
  _OpenScreenState createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> {
  InterstitialAd _interstitialAd;
  List<String>  _holidayListInfo;

  bool _isInterstitialAdReady;

  void _loadInterstitialAd() {
    _interstitialAd.load();
    _interstitialAd.show();
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;

        fetchMarketHolidayInfo();
        //print('%^%^%^%^%^%');
        //print(_holidayListInfo);
        //print('%^%^%^%^%^%');
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DibrContentPage(holidayInfo: _holidayListInfo)));
        break;
      case MobileAdEvent.closed:
        _isInterstitialAdReady = true;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DibrContentPage(holidayInfo: _holidayListInfo)));
        break;
      default:
      // do nothing
    }
  }

  void _onClick() {
    print('_onClick() 호출됨');
    setState(() {
      _loadInterstitialAd();
    });
  }

  @override
  void initState() {
    _isInterstitialAdReady = false;

    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
  }

  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void fetchMarketHolidayInfo() async {
    final response = await http.get(Uri.encodeFull(
        'http://dibr2020.cafe24app.com/marketInfo/getMarketHolidayList/KSP'));
    //headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      _holidayListInfo = [];
      List dataList = jsonDecode(response.body);
      var dataLength = dataList.length;
      print("1####################################");
      print(dataLength);
      Map dataJson;
      var dataStock;
      //print(dataJson[kspStockDate]);
      for (var vHoliday in dataList) {
        //etfStocks.add(etfStock);
        //dataJson = etfStock;
        dataStock = null;
        //dataStock = MarketHolidayInfo.fromJson(vHoliday);
        _holidayListInfo.add(vHoliday['kspStockDate']);
        //holidayInfo.add(vHoliday);
        //rtnEtfStocks.add(dataStock);
        //print(rtnEtfStocks[0]);
        //print(rtnEtfStocks[1]);
      }
      print("2####################################");
      //var marketInfo = ;
      print(_holidayListInfo);
      //return rtnHoliday;
    } else {
      throw Exception('Failed to load MarketInfo');
    }

  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //세로고정

    Timer(Duration(seconds: 3), () {
      print("Yeah, this line is printed after 3 seconds");
      _loadInterstitialAd();
      _interstitialAd.show();
    });

    return Scaffold(
        body: Container(
            child: SafeArea(
                child: ListView(children: <Widget>[
      Stack(
        children: <Widget>[
          Container(
              width: double.maxFinite,
              child: ClipRRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                          alignment: Alignment.center,
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 150,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 15, 20, 40),
                                child: Image.asset('images/frontImg.jpeg',
                                    fit: BoxFit.fill),
                                height: screenSize.height - 400,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: RaisedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.play_arrow,
                                          size: 40.0,
                                          color: Colors.white,
                                        ),
                                        Text("시작하기",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.white)),
                                      ],
                                    ),
                                    color: Colors.indigoAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    onPressed: () {
                                      _onClick();
                                    },
                                  ),
                                ),
                              )
                            ],
                          )))))),
        ],
      ),
    ]))));
  }
}
