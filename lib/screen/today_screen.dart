import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/widgets.dart';
import "package:flutter_dibr_do_kospi/ad_manager.dart";
import "package:flutter_dibr_do_kospi/main.dart";
import "package:flutter_dibr_do_kospi/model/model_market.dart";
import "package:flutter_dibr_do_kospi/screen/etfStockInfo_screen.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DibrTodayPage extends StatefulWidget {
  @override
  _DibrTodayPageState createState() => _DibrTodayPageState();
}

class _DibrTodayPageState extends State<DibrTodayPage> {
  Future<MarketInfo> futureMarketInfo;

  //DateTime _selectedTime = DateTime.now();

  String _selectedDtHh =
      new DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());

  String _selectedHh = new DateFormat("HH").format(DateTime.now());

  String _selectedMm = new DateFormat("mm").format(DateTime.now());

  String _selectedEtf;

  //bool _isRewardedAdReady;

  @override
  void initState() {
    super.initState();
    RewardedVideoAd.instance.listener = _onRewardedAdEvent;

    futureMarketInfo = fetchMarketInfo('Init');
  }

  void _onRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          //      _isRewardedAdReady = true;
        });
        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          //    _isRewardedAdReady = false;
        });
        RewardedVideoAd.instance.load(
          targetingInfo: MobileAdTargetingInfo(),
          adUnitId: AdManager.rewardedAdUnitId,
        );
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          //  _isRewardedAdReady = true;
          futureMarketInfo = fetchMarketInfo('Today');
        });
        print('Failed to load a rewarded ad');

        break;
      case RewardedVideoAdEvent.rewarded:
        setState(() {
          futureMarketInfo = fetchMarketInfo('Today');
        });
        break;
      default:
      // do nothing
    }
  }

  Color getColor(number) {
    if (number == null || number == 'undefined') {
      number = 0;
    }

    if (number >= 0) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  Color getCalendarColor(pH, pM) {
    int intH = int.parse(pH);
    int intM = int.parse(pM);
    if (intH < 9) {
      return Colors.white;
    } else if (intH < 15) {
      return Colors.black;
    } else if (intH == 15) {
      if (intM < 30) {
        return Colors.black;
      } else {
        return Colors.white;
      }
    } else {
      return Colors.white;
    }
  }

  String getSelectStock(pTp1, pTp2, pTp3) {
    if (pTp3 == 1) {
      if (pTp1 == "R") {
        if (pTp2 == "N") {
          return "Leverage";
        } else {
          return "Inverse2X";
        }
      } else {
        if (pTp2 == "N") {
          return "Inverse2X";
        } else {
          return "Leverage";
        }
      }
    } else {
      if (pTp1 == "R") {
        if (pTp2 == "N") {
          return "Inverse2X";
        } else {
          return "Leverage";
        }
      } else {
        if (pTp2 == "N") {
          return "Leverage";
        } else {
          return "Inverse2X";
        }
      }
    }
  }

  IconData getTimeIcon(pH, pM) {
    int intH = int.parse(pH);
    int intM = int.parse(pM);
    if (intH < 9) {
      return Icons.brightness_6;
    } else if (intH < 15) {
      return Icons.brightness_low;
    } else if (intH == 15) {
      if (intM < 30) {
        return Icons.brightness_low;
      } else {
        return Icons.brightness_3;
      }
    } else {
      return Icons.brightness_3;
    }
  }

  Color getTimeBackgroundColor(pH, pM) {
    int intH = int.parse(pH);
    int intM = int.parse(pM);
    if (intH < 9) {
      return Colors.grey;
    } else if (intH < 15) {
      return Colors.white;
    } else if (intH == 15) {
      if (intM < 30) {
        return Colors.white;
      } else {
        return Colors.blueGrey;
      }
    } else {
      return Colors.blueGrey;
    }
  }

  ThemeData getTheme(pH, pM) {
    int intH = int.parse(pH);
    int intM = int.parse(pM);
    if (intH < 9) {
      return ThemeData.light();
    } else if (intH < 15) {
      return ThemeData.light();
    } else if (intH == 15) {
      if (intM < 30) {
        return ThemeData.light();
      } else {
        return ThemeData.light();
      }
    } else {
      return ThemeData.light();
    }
  }

  IconData getIcon(number) {
    if (number == null || number == 'undefined') {
      number = 0;
    }

    if (number > 0) {
      return Icons.trending_up;
    } else if (number < 0) {
      return Icons.trending_down;
    } else {
      return null;
    }
  }

  IconData getUpDownIcon(number) {
    if (number == null || number == 'undefined') {
      number = 0;
    }
    if (number > 0) {
      return Icons.arrow_upward;
    } else if (number < 0) {
      return Icons.arrow_downward;
    } else {
      return null;
    }
  }

  Future<MarketInfo> fetchMarketInfo(pType) async {
    if (pType == 'Init') {
      print('pType:' + pType);
      return MarketInfo.fromInitJson();
    } else {
      print('@@@@@@@@@@@@@@@@@@@@로드??');
      final response = await http.get(Uri.encodeFull(
          'http://dibr.cafe24app.com/marketInfo/getMarketInfoDay'));
      //headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        Map dataJson = jsonDecode(response.body);
        print("1####################################");
        print(dataJson);
        print(dataJson[snpScore]);
        print("2####################################");
        //var marketInfo = ;
        return MarketInfo.fromJson(dataJson);
      } else {
        throw Exception('Failed to load MarketInfo');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body:
        ListView(
            scrollDirection: Axis.vertical,
            //padding: const EdgeInsets.only(bottom: 48.0),
            padding: MediaQuery.of(context).padding.copyWith(
              left: 0,
              right: 0,
              bottom: 50,
            ),
            children: <Widget>[
              StreamBuilder(
              stream: futureMarketInfo.asStream(),
              builder: (BuildContext context, snapshot) {
                final marketInfo = snapshot.data;
                print('snapshot~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                print(snapshot);
                if (snapshot.hasData) {
                  print('snp~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                  print(snapshot);
                  print('snp~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                  print(snapshot.data.snpEndPrice);
                  print(snapshot.data.snpUdRateRealByClose);
                  print(snapshot.data.snpUdPrice);

                  return Container(
                    margin: EdgeInsets.all(3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'images/bg1.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Column(children: <Widget>[
                              SizedBox(height: 50),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        'images/bg11.png',
                                        height: 65,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                    ),
                                    Container(
                                      color: getTimeBackgroundColor(
                                          '$_selectedHh', '$_selectedMm'),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            InkWell(
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      getTimeIcon(
                                                          '$_selectedHh',
                                                          '$_selectedMm'),
                                                      size: iconSize,
                                                      color: Colors.redAccent,
                                                    ),
                                                    Text('$_selectedDtHh',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: getCalendarColor(
                                                              '$_selectedHh',
                                                              '$_selectedMm'),
                                                        )),
                                                  ]),
                                              onTap: () {},
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.calendar_today,
                                                color: getCalendarColor(
                                                    '$_selectedHh',
                                                    '$_selectedMm'),
                                              ),
                                              iconSize: 25,
                                              tooltip:
                                                  'Tap to open date picker',
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            ]),
                          ],
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.black,
                              height: 41,
                              width: 217,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        fontStyle: FontStyle.normal,
                                        backgroundColor: Colors.redAccent,
                                        letterSpacing: 2.0,
                                      )),
                                  Text(' Today 시장 정보 ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2.0,
                                          color: Colors.white)),
                                ]),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2,2,2,0),
                                    height: 120,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 3.0,right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Image.asset('images/snp_logo.png',height: 70,width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Container(
                                                              child:
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.green)),
                                                                    Align(
                                                                      alignment: Alignment.centerRight,
                                                                      child: Text(
                                                                        '${snapshot.data.snpStdPrice} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 11,
                                                                          color: Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.snpEndPrice} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot.data.snpUdRateRealByClose),
                                                                        size: 14,
                                                                        color: getColor(snapshot.data.snpUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.snpUdRateRealByClose}%[${snapshot.data.snpUdPrice}] ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: getColor(snapshot.data.snpUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text('편차 스코어:',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                              color: Colors.black87)),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(snapshot.data.snpScore),
                                                            size: 24,
                                                            color: getColor(snapshot.data.snpScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.snpScore} ',
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18,
                                                                color: getColor(snapshot.data.snpScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2,2,2,0),
                                    height: 120,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 3.0,right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Image.asset('images/euro_logo.png',height: 70,width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Container(
                                                              child:
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.green)),
                                                                    Align(
                                                                      alignment: Alignment.centerRight,
                                                                      child: Text(
                                                                        '${snapshot.data.eurStdPrice} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 11,
                                                                          color: Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.eurEndPrice} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot.data.eurUdRateRealByClose),
                                                                        size: 14,
                                                                        color: getColor(snapshot.data.eurUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.eurUdRateRealByClose}%[${snapshot.data.eurUdPrice}] ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: getColor(snapshot.data.eurUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text('편차 스코어:',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                              color: Colors.black87)),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(snapshot.data.eurScore),
                                                            size: 24,
                                                            color: getColor(snapshot.data.eurScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.eurScore} ',
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18,
                                                                color: getColor(snapshot.data.eurScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2,2,2,0),
                                    height: 120,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 3.0,right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Image.asset('images/wtinew_logo.png',height: 70,width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Container(
                                                              child:
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.green)),
                                                                    Align(
                                                                      alignment: Alignment.centerRight,
                                                                      child: Text(
                                                                        '${snapshot.data.wtiStdPrice} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 11,
                                                                          color: Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.wtiEndPrice} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot.data.wtiUdRateRealByClose),
                                                                        size: 14,
                                                                        color: getColor(snapshot.data.wtiUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.wtiUdRateRealByClose}%[${snapshot.data.wtiUdPrice}] ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: getColor(snapshot.data.wtiUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text('편차 스코어:',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                              color: Colors.black87)),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(snapshot.data.wtiScore),
                                                            size: 24,
                                                            color: getColor(snapshot.data.wtiScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.wtiScore} ',
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18,
                                                                color: getColor(snapshot.data.wtiScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2,2,2,0),
                                    height: 120,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 3.0,right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Image.asset('images/dubai_logo.png',height: 70,width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Container(
                                                              child:
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.green)),
                                                                    Align(
                                                                      alignment: Alignment.centerRight,
                                                                      child: Text(
                                                                        '${snapshot.data.dubStdPrice} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 11,
                                                                          color: Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.dubEndPrice} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot.data.dubUdRateRealByClose),
                                                                        size: 14,
                                                                        color: getColor(snapshot.data.dubUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.dubUdRateRealByClose}%[${snapshot.data.dubUdPrice}] ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: getColor(snapshot.data.dubUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text('편차 스코어:',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                              color: Colors.black87)),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(snapshot.data.dubScore),
                                                            size: 24,
                                                            color: getColor(snapshot.data.dubScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.dubScore} ',
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18,
                                                                color: getColor(snapshot.data.dubScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2,2,2,0),
                                    height: 120,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 3.0,right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Image.asset('images/brent_logo.png',height: 70,width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Container(
                                                              child:
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.green)),
                                                                    Align(
                                                                      alignment: Alignment.centerRight,
                                                                      child: Text(
                                                                        '${snapshot.data.breStdPrice} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 11,
                                                                          color: Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.breEndPrice} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot.data.breUdRateRealByClose),
                                                                        size: 14,
                                                                        color: getColor(snapshot.data.breUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.breUdRateRealByClose}%[${snapshot.data.breUdPrice}] ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: getColor(snapshot.data.breUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text('편차 스코어:',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                              color: Colors.black87)),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(snapshot.data.breScore),
                                                            size: 24,
                                                            color: getColor(snapshot.data.breScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.breScore} ',
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18,
                                                                color: getColor(snapshot.data.breScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2,2,2,0),
                                    height: 120,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 3.0,right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Image.asset('images/excnew_logo.png',height: 70,width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Container(
                                                              child:
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.green)),
                                                                    Align(
                                                                      alignment: Alignment.centerRight,
                                                                      child: Text(
                                                                        '${snapshot.data.bfStdRate} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 11,
                                                                          color: Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.tdOpRate} ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot.data.excDiffRate),
                                                                        size: 14,
                                                                        color: getColor(snapshot.data.excDiffRate),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.excDiffRate}%[${snapshot.data.excDiffPrice}] ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: getColor(snapshot.data.excDiffRate)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text('편차 스코어:',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                              color: Colors.black87)),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(snapshot.data.excScore1st),
                                                            size: 24,
                                                            color: getColor(snapshot.data.excScore1st),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.excScore1st} ',
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18,
                                                                color: getColor(snapshot.data.excScore1st)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.black,
                              height: 41,
                              width: 214,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        fontStyle: FontStyle.normal,
                                        backgroundColor: Colors.redAccent,
                                        letterSpacing: 2.0,
                                      )),
                                  Text('  투자 점수[등급]  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2.0,
                                          color: Colors.white)),
                                ]),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Table(
                            // columnWidths: ,
                            border: TableBorder(
                              bottom: BorderSide(
                                color: Colors.blueGrey,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              horizontalInside: BorderSide(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              left: BorderSide(
                                style: BorderStyle.none,
                              ),
                              right: BorderSide(
                                style: BorderStyle.none,
                              ),
                              top: BorderSide(
                                style: BorderStyle.none,
                              ),
                              verticalInside: BorderSide(
                                style: BorderStyle.none,
                              ),
                            ),
                            columnWidths: {
                              0: FractionColumnWidth(.5),
                              1: FractionColumnWidth(.5)
                            },
                            children: [
                              TableRow(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('＄/￦환율 제외 전체',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('＄/￦환율',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ]),
                              ]),
                              TableRow(children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        getIcon(snapshot.data.exRauTotScore),
                                        size: 35,
                                        color: getColor(
                                            snapshot.data.exRauTotScore),
                                      ),
                                      Text(
                                          '${snapshot.data.exRauTotScore}[${snapshot.data.exRauTotScoreGrade}] ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: getColor(snapshot
                                                  .data.exRauTotScore))),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        getIcon(snapshot.data.excScore1st),
                                        size: 35,
                                        color:
                                            getColor(snapshot.data.excScore1st),
                                      ),
                                      Text(
                                          //' $_excScore1st [$_excSetRngGrp]',
                                          '${snapshot.data.excScore1st}[${snapshot.data.excSetRngGrp}] ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: getColor(
                                                  snapshot.data.excScore1st))),
                                    ]),
                              ]),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.black,
                              height: 41,
                              width: 219,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        fontStyle: FontStyle.normal,
                                        backgroundColor: Colors.redAccent,
                                        letterSpacing: 2.0,
                                      )),
                                  Text('      투자 추천       ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2.0,
                                          color: Colors.white)),
                                  Text(' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                          fontStyle: FontStyle.normal,
                                          backgroundColor: Colors.redAccent,
                                          letterSpacing: 2.0)),
                                ]),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.all(3),
                          child: Table(
                            // columnWidths: ,
                            border: TableBorder(
                              bottom: BorderSide(
                                color: Colors.white54,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              horizontalInside: BorderSide(
                                color: Colors.white54,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              left: BorderSide(
                                color: Colors.white54,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              right: BorderSide(
                                color: Colors.white54,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Colors.white54,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              verticalInside: BorderSide(
                                style: BorderStyle.none,
                              ),
                            ),
                            columnWidths: {
                              0: FractionColumnWidth(.20),
                              1: FractionColumnWidth(.25),
                              2: FractionColumnWidth(.30),
                              3: FractionColumnWidth(.25)
                            },
                            children: [
                              TableRow(children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.bookmark,
                                        size: iconSize,
                                        color: Colors.blue,
                                      ),
                                      Text('매수순위',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.done,
                                        size: iconSize,
                                        color: Colors.redAccent,
                                      ),
                                      Text('선택종목',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.alarm_on,
                                        size: iconSize,
                                        color: Colors.redAccent,
                                      ),
                                      Text('매수예약(%)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.alarm_off,
                                        size: iconSize,
                                        color: Colors.blueAccent,
                                      ),
                                      Text('손절(%)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ]),
                              ]),
                              TableRow(children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.looks_one,
                                        size: iconSize,
                                        color: Colors.redAccent,
                                      ),
                                      Text('순위')
                                    ]),
                                Text(
                                  getSelectStock(snapshot.data.selectStock,
                                      snapshot.data.otType, 2),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        getIcon(snapshot.data.buyRate1st),
                                        size: 25,
                                        color:
                                            getColor(snapshot.data.buyRate1st),
                                      ),
                                      Text('${snapshot.data.buyRate1st}% ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: getColor(
                                                  snapshot.data.buyRate1st))),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        getIcon(snapshot.data.minusDecide1st),
                                        size: 25,
                                        color: getColor(
                                            snapshot.data.minusDecide1st),
                                      ),
                                      Text('${snapshot.data.minusDecide1st}% ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: getColor(snapshot
                                                  .data.minusDecide1st))),
                                    ]),
                              ]),
                              TableRow(children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.looks_two,
                                        size: iconSize,
                                        color: Colors.lightBlueAccent,
                                      ),
                                      Text('순위')
                                    ]),
                                Text(
                                  getSelectStock(snapshot.data.selectStock,
                                      snapshot.data.otType, 1),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        getIcon(snapshot.data.buyRate2nd),
                                        size: 25,
                                        color:
                                            getColor(snapshot.data.buyRate2nd),
                                      ),
                                      Text('${snapshot.data.buyRate2nd}% ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: getColor(
                                                  snapshot.data.buyRate2nd))),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        getIcon(snapshot.data.minusDecide2nd),
                                        size: 25,
                                        color: getColor(
                                            snapshot.data.minusDecide2nd),
                                      ),
                                      Text('${snapshot.data.minusDecide2nd}% ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: getColor(snapshot
                                                  .data.minusDecide2nd))),
                                    ]),
                              ]),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Text("매수예약은 종목의 시작가 대비(%)입니다.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  letterSpacing: 2.0,
                                ))),
                        SizedBox(height: 10),
                        Container(
                            padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                            height: 300,
                            width: 420,
                            child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3, top: 5),
                              child: Table(
                          // columnWidths: ,
                          border: TableBorder(
                            bottom: BorderSide(
                              color: Colors.blueGrey,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            horizontalInside: BorderSide(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            left: BorderSide(
                              style: BorderStyle.none,
                            ),
                            right: BorderSide(
                              style: BorderStyle.none,
                            ),
                            top: BorderSide(
                              style: BorderStyle.none,
                            ),
                            verticalInside: BorderSide(
                              style: BorderStyle.none,
                            ),
                          ),
                          columnWidths: {
                            0: FractionColumnWidth(.35),
                            1: FractionColumnWidth(.35),
                            2: FractionColumnWidth(.3)
                          },
                          children: [
                            TableRow(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.score,
                                      size: iconSize,
                                      color: Colors.blue,
                                    ),
                                    Text('Market',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      size: iconSize,
                                      color: Colors.redAccent,
                                    ),
                                    Text('Price',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.grade,
                                      size: iconSize,
                                      color: Colors.greenAccent,
                                    ),
                                    Text('Score',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  ]),
                            ]),
                            TableRow(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/usa.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Text('S&P500')
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${snapshot.data.snpEndPrice} ',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        '${snapshot.data.snpUdRateRealByClose}%[${snapshot.data.snpUdPrice}] ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(snapshot
                                                .data.snpUdRateRealByClose))),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      getIcon(snapshot.data.snpScore),
                                      size: 35,
                                      color: getColor(snapshot.data.snpScore),
                                    ),
                                    Text('${snapshot.data.snpScore} ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.snpScore))),
                                  ]),
                            ]),
                            TableRow(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/euro.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Text('EURO')
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${snapshot.data.eurEndPrice} ',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        '${snapshot.data.eurUdRateRealByClose}%[${snapshot.data.eurUdPrice}] ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(snapshot
                                                .data.eurUdRateRealByClose))),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      getIcon(snapshot.data.eurScore),
                                      size: 35,
                                      color: getColor(snapshot.data.eurScore),
                                    ),
                                    Text('${snapshot.data.eurScore} ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.eurScore))),
                                  ]),
                            ]),
                            TableRow(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/oil.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Text('WTI OIL')
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${snapshot.data.wtiEndPrice} ',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        '${snapshot.data.wtiUdRateRealByClose}%[${snapshot.data.wtiUdPrice}] ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(snapshot
                                                .data.wtiUdRateRealByClose))),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      getIcon(snapshot.data.wtiScore),
                                      size: 35,
                                      color: getColor(snapshot.data.wtiScore),
                                    ),
                                    Text('${snapshot.data.wtiScore} ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.wtiScore))),
                                  ]),
                            ]),
                            TableRow(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/oil.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Text('DUB OIL')
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${snapshot.data.dubEndPrice} ',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        '${snapshot.data.dubUdRateRealByClose}%[${snapshot.data.dubUdPrice}] ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(snapshot
                                                .data.dubUdRateRealByClose))),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      getIcon(snapshot.data.dubScore),
                                      size: 35,
                                      color: getColor(snapshot.data.dubScore),
                                    ),
                                    Text('${snapshot.data.dubScore} ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.dubScore))),
                                  ]),
                            ]),
                            TableRow(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/oil.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Text('BRE OIL')
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${snapshot.data.breEndPrice} ',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        '${snapshot.data.breUdRateRealByClose}%[${snapshot.data.breUdPrice}] ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(snapshot
                                                .data.breUdRateRealByClose))),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      getIcon(snapshot.data.breScore),
                                      size: 35,
                                      color: getColor(snapshot.data.breScore),
                                    ),
                                    Text('${snapshot.data.breScore} ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.breScore))),
                                  ]),
                            ]),
                            TableRow(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/exc.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Text('   ＄/￦')
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${snapshot.data.tdOpRate} ',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                        '${snapshot.data.excDiffRate}%[${snapshot.data.excDiffPrice}] ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.excDiffRate))),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      getIcon(snapshot.data.excScore1st),
                                      size: 35,
                                      color:
                                          getColor(snapshot.data.excScore1st),
                                    ),
                                    Text('${snapshot.data.excScore1st} ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.excScore1st))),
                                  ]),
                            ]),
                          ],
                        ),
                            )
                            )
                          )
                            ),
                        SizedBox(height: 50),
                        SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                              child: RaisedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.redo,
                                      size: 40.0,
                                      color: Colors.white,
                                    ),
                                    Text("ETF 종목 정보 조회",
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white)),
                                  ],
                                ),
                                color: Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(20.0)),
                                onPressed: () {
                                  var openStandardData = snapshot.data.kspOpenPrice;
                                  if(openStandardData == 'undefined' || openStandardData == null || openStandardData == 0.0){
                                    showDialog(
                                    context: context,
                                    builder: (context)
                                    {
                                      return AlertDialog(
                                        title: Text('[Info]'),
                                        content: Text(
                                            '장 시작 후 시장 정보 조회를 하셔야합니다!'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('ok'.toUpperCase()),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                  }else{
                                    Navigator.of(context).push(MaterialPageRoute<Null>(
                                        fullscreenDialog: true,
                                        builder: (BuildContext context){
                                          return DibrEtfStockInfoPage(marketInfo: marketInfo);
                                        }
                                    ));
                                  }
                                },
                              ),)),
                        SizedBox(height: 300),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  print('error!');
                  print("${snapshot.error}");
                  return Text("${snapshot.error}");
                }

                return CircularProgressIndicator();
              }),
        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 48.0),
          child: FloatingActionButton.extended(
              label: Text(
                '(Ad)시장 정보 조회',
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0),
              ),
              icon: Icon(
                Icons.movie,
                size: 25,
              ),
              backgroundColor: Colors.green,
              onPressed: () {
                print(exRtScore.abs());
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Need a StockInfo?'),
                      content: Text('Watch an Ad to get a information!'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('cancel'.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text('ok'.toUpperCase()),
                          onPressed: () {
                            RewardedVideoAd.instance.listener =
                                _onRewardedAdEvent;
                            Navigator.pop(context);
                            RewardedVideoAd.instance.show();
                            //RestApi_Get();
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
        ));
  }
}

class EtfItem {
  const EtfItem(this.id, this.name, this.icon);

  final String name;
  final String id;
  final Icon icon;
}
