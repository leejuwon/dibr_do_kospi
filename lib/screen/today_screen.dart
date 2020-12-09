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
  final List<String> holidayInfo;

  DibrTodayPage({this.holidayInfo});

  @override
  _DibrTodayPageState createState() => _DibrTodayPageState();
}

class _DibrTodayPageState extends State<DibrTodayPage> {
  Future<MarketInfo> futureMarketInfo;
  List<String> _holidayInfo;

  //DateTime _selectedTime = DateTime.now();

  String _selectedDtHh =
      new DateFormat("yyyy-MM-dd").format(DateTime.now());

  String _selectedHh = new DateFormat("HH").format(DateTime.now());

  String _selectedMm = new DateFormat("mm").format(DateTime.now());

  var _selectedDay = DateTime.now().weekday;


  String _selectedEtf;

  //bool _isRewardedAdReady;

  @override
  void initState() {
    super.initState();

    _holidayInfo = widget.holidayInfo;
    print('!@#');
    print(_holidayInfo);
    print(this._holidayInfo);
    print('!@#');
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

  Image getImage(pTp1, pTp2, pTp3) {
    //getSelectStock(snapshot.data.selectStock, snapshot.data.otType, 1)
    if (pTp3 == 1) {
      if (pTp1 == "L") {
        if (pTp2 == "N") {
          return Image.asset('images/leverage_logo_2.png', height: 100, width: 100);
        } else {
          return Image.asset('images/inverse_logo_2.png', height: 100, width: 100);
        }
      } else {
        if (pTp2 == "N") {
          return Image.asset('images/inverse_logo_2.png', height: 100, width: 100);
        } else {
          return Image.asset('images/leverage_logo_2.png', height: 100, width: 100);
        }
      }
    } else {
      if (pTp1 == "L") {
        if (pTp2 == "N") {
          return Image.asset('images/inverse_logo_2.png', height: 100, width: 100);
        } else {
          return Image.asset('images/leverage_logo_2.png', height: 100, width: 100);
        }
      } else {
        if (pTp2 == "N") {
          return Image.asset('images/leverage_logo_2.png', height: 100, width: 100);
        } else {
          return Image.asset('images/inverse_logo_2.png', height: 100, width: 100);
        }
      }
    }
  }

  Color getColor(number) {
    if (number == null || number == 'undefined') {
      number = 0;
    }

    if (number > 0) {
      return Colors.red;
    } else if (number < 0) {
      return Colors.blue;
    } else {
      return Colors.black54;
    }
  }

  String chkHoliday(pDate) {
    print('pDate:'+ pDate);
    print(_holidayInfo);
    print(_holidayInfo.length);
    if (pDate == null || pDate == 'undefined') {
      return 'N';
    }
    var resultYn = 'N';

    for(var i = 0; i < _holidayInfo.length; i = i + 1 ){
      if(_holidayInfo[i] == pDate){
        resultYn =  'Y';
      }
    }

    return resultYn;
  }

  String getNumberWithComma(pNum){
    if (pNum == null || pNum == 'undefined') {
      return "0.00 ";
    }else{
      return new NumberFormat('###,###,###,###.##').format(pNum).replaceAll(' ', '')+" ";
    }

  }

  String getBuyRate(pNum, pCond){
    if (pNum == null || pNum == 'undefined') {
      return "0.0% ";
    }else if (pNum == 0.0 || pNum == 0) {
      if(pCond != null && pCond != 'undefined' && pCond != 0){
        return "시작가 매수 ";
      }else{
        return "0.0% ";
      }
    }else{
      return pNum.toString() + '% ';
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
      if (pTp1 == "L") {
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
      if (pTp1 == "L") {
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
      return Colors.black54;
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

  String getUpDownString(number) {
    if (number == null || number == 'undefined') {
      number = 0;
    }
    if (number > 0) {
      return "▲";
    } else if (number < 0) {
      return "▼";
    } else {
      return " ";
    }
  }

  Future<MarketInfo> fetchMarketInfo(pType) async {
    if (pType == 'Init') {
      print('pType:' + pType);
      return MarketInfo.fromInitJson();
    } else {
      print('@@@@@@@@@@@@@@@@@@@@로드??');
      final response = await http.get(Uri.encodeFull(
          'http://dibr2020.cafe24app.com/marketInfo/getMarketInfoDay'));
      //headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        Map dataJson = jsonDecode(response.body);
        print("1####################################");
        print(dataJson);
        print(dataJson[snpScore]);
        print("2####################################");
        _selectedDtHh =  new DateFormat("yyyy-MM-ddH:mm").format(DateTime.now());
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
        backgroundColor: Colors.white10,
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
                        Stack(
                          children: <Widget>[
                            /*Container(
                              child: Image.asset(
                                'images/todayBg.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),*/
                            Column(children: <Widget>[
                              SizedBox(height: 20),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        'images/logo_transparent.png',
                                        height: 45,
                                      ),
                                    ),
                                    Text('기준일: ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: 2.0,
                                            color: Colors.black54)),
                                    Text('$_selectedDtHh',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          fontStyle: FontStyle.normal,
                                        )),
                                  ]),
                            ]),
                          ],
                        ),
                        SizedBox(height: 20),
                        Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.white38,
                              height: 41,
                              width: 217,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' Today 시장 정보 ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2.0,
                                          color: Colors.blueGrey)),
                                ]
                            ),
                          ],
                        ),
                        Container(
                          color: Colors.white38,
                          height: 3,
                          width: 380,
                          child: Table(border: TableBorder(
                            bottom: BorderSide(
                              color: Colors.blueGrey,
                              style: BorderStyle.solid,
                              width: 2.0,
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
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(12, 2, 2, 0),
                                height: 190,
                                width: 390,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 3.0,
                                                        right: 3.0),
                                                    child: Align(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Image.asset(
                                                          'images/usa.png',
                                                          height: 120,
                                                          width: 140),
                                                    ),
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text('기준가:',
                                                                    style:
                                                                      TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 16,
                                                                        color: Colors.black38,
                                                                      ),

                                                                    ),
                                                                Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .centerRight,
                                                                  child:
                                                                  Text(
                                                                    getNumberWithComma(snapshot.data.snpStdPrice),
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(                                                                       
                                                                        fontSize: 20,
                                                                        color: Colors.black54),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                            width: 185,
                                                            child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(' 종   가:',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 16,
                                                                      color: Colors.black38)),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  Text(
                                                                    getNumberWithComma(snapshot.data.snpEndPrice),
                                                                    textAlign:
                                                                    TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: Colors.black54),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                            width: 185,
                                                            child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  Stack(
                                                                    children: <Widget>[
                                                                      Stack(
                                                                        children: <Widget>[
                                                                          Text(
                                                                            '${snapshot.data.snpUdRateRealByClose}%[ '+getNumberWithComma(snapshot.data.snpUdPrice)+'] ',
                                                                            textAlign:
                                                                            TextAlign.end,
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                color: getColor(
                                                                                    snapshot.data.snpUdRateRealByClose)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                      ]),
                                                ],
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.only(left: 5, right: 20),
                                                  child:Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,

                                                    children: <Widget>[
                                                      Text('  S&P500 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 18,
                                                              color: Colors
                                                                  .blueGrey)),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .end,
                                                        children: [
                                                          Container(
                                                            height: 40,
                                                            width: 150,
                                                            padding: EdgeInsets.fromLTRB(12, 2, 2, 0),
                                                            decoration: BoxDecoration(
                                                                color: getColor(snapshot.data.snpScore),
                                                                shape: BoxShape.rectangle,
                                                                borderRadius: BorderRadius.circular(8.0)),
                                                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                              Text(getUpDownString(snapshot.data.snpScore),
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 20,
                                                                    color: Colors.white,
                                                                  )),
                                                              Text('${snapshot.data.snpScore} ',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 24,
                                                                    color: Colors.white,
                                                                  )),
                                                            ]),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                              ),
                                              ],
                                          ))),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(12, 2, 2, 0),
                                height: 190,
                                width: 390,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 3.0,
                                                        right: 3.0),
                                                    child: Align(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Image.asset(
                                                          'images/euro.png',
                                                          height: 120,
                                                          width: 140),
                                                    ),
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text('기준가:',
                                                                  style:
                                                                  TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16,
                                                                    color: Colors.black38,
                                                                  ),

                                                                ),
                                                                Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .centerRight,
                                                                  child:
                                                                  Text(
                                                                    getNumberWithComma(snapshot.data.eurStdPrice),
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: Colors.black54),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(' 종   가:',
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 16,
                                                                        color: Colors.black38)),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Text(
                                                                      getNumberWithComma(snapshot.data.eurEndPrice),
                                                                      textAlign:
                                                                      TextAlign.end,
                                                                      style: TextStyle(
                                                                          fontSize: 20,
                                                                          color: Colors.black54),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Stack(
                                                                      children: <Widget>[
                                                                        Text(
                                                                          '${snapshot.data.eurUdRateRealByClose}%[ '+getNumberWithComma(snapshot.data.eurUdPrice)+'] ',
                                                                          textAlign:
                                                                          TextAlign.end,
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: getColor(
                                                                                  snapshot.data.eurUdRateRealByClose)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                      ]),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 20),
                                                child:Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,

                                                  children: <Widget>[
                                                    Text('   EURO50 점수:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 18,
                                                            color: Colors
                                                                .blueGrey)),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end,
                                                      children: [
                                                        Container(
                                                          height: 45,
                                                          width: 150,
                                                          decoration: BoxDecoration(
                                                              color: getColor(snapshot.data.eurScore),
                                                              shape: BoxShape.rectangle,
                                                              borderRadius: BorderRadius.circular(8.0)),
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                            Text(getUpDownString(snapshot.data.eurScore),
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20,
                                                                  color: Colors.white,
                                                                )),
                                                            Text('${snapshot.data.eurScore} ',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 24,
                                                                  color: Colors.white,
                                                                )),
                                                          ]),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ],
                                          ))),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(12, 2, 2, 0),
                                height: 360,
                                width: 390,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 3.0,
                                                        right: 3.0),
                                                    child: Align(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Image.asset(
                                                          'images/oil_logo.png',
                                                          height: 210,
                                                          width: 140),
                                                    ),
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text('WTI유가:',
                                                                  style:
                                                                  TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16,
                                                                    color: Colors.black38,
                                                                  ),

                                                                ),
                                                                Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .centerRight,
                                                                  child:
                                                                  Text(
                                                                    getNumberWithComma(snapshot.data.wtiEndPrice),
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: Colors.black54),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text('WTI점수:',
                                                                  style:
                                                                  TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16,
                                                                    color: Colors.black38,
                                                                  ),

                                                                ),
                                                                Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .centerRight,
                                                                  child:
                                                                  Text(
                                                                    getUpDownString(snapshot.data.wtiScore) + '${snapshot.data.wtiScore} ',
                                                                    textAlign:
                                                                    TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: getColor(snapshot.data.wtiScore)),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Stack(
                                                                      children: <Widget>[
                                                                        Text(
                                                                          '${snapshot.data.wtiUdRateRealByClose}%[ '+getNumberWithComma(snapshot.data.wtiUdPrice)+'] ',
                                                                          textAlign:
                                                                          TextAlign.end,
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: getColor(snapshot.data.wtiUdRateRealByClose)
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(' DUBAI유가:',
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 16,
                                                                        color: Colors.black38)),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Text(
                                                                      getNumberWithComma(snapshot.data.dubEndPrice),
                                                                      textAlign:
                                                                      TextAlign.end,
                                                                      style: TextStyle(
                                                                          fontSize: 20,
                                                                          color: Colors.black54),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(' DUBAI점수:',
                                                                  style:
                                                                  TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16,
                                                                    color: Colors.black38,
                                                                  ),

                                                                ),
                                                                Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .centerRight,
                                                                  child:
                                                                  Text(
                                                                    getUpDownString(snapshot.data.dubScore) + '${snapshot.data.dubScore} ',
                                                                    textAlign:
                                                                    TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: getColor(snapshot.data.dubScore)),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Stack(
                                                                      children: <Widget>[
                                                                        Text(
                                                                          '${snapshot.data.dubUdRateRealByClose}%[ '+getNumberWithComma(snapshot.data.dubUdPrice)+'] ',
                                                                          textAlign:
                                                                          TextAlign.end,
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: getColor(snapshot.data.dubUdRateRealByClose)
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(' BRENT유가:',
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 16,
                                                                        color: Colors.black38)),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Text(
                                                                      getNumberWithComma(snapshot.data.breEndPrice),
                                                                      textAlign:
                                                                      TextAlign.end,
                                                                      style: TextStyle(
                                                                          fontSize: 20,
                                                                          color: Colors.black54),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(' BRENT점수:',
                                                                  style:
                                                                  TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16,
                                                                    color: Colors.black38,
                                                                  ),

                                                                ),
                                                                Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .centerRight,
                                                                  child:
                                                                  Text(
                                                                    getUpDownString(snapshot.data.breScore) + '${snapshot.data.breScore} ',
                                                                    textAlign:
                                                                    TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: getColor(snapshot.data.breScore)),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Stack(
                                                                      children: <Widget>[
                                                                        Text(
                                                                          '${snapshot.data.breUdRateRealByClose}%[ '+getNumberWithComma(snapshot.data.breUdPrice)+'] ',
                                                                          textAlign:
                                                                          TextAlign.end,
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: getColor(snapshot.data.breUdRateRealByClose)
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                      ]),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 20),
                                                child:Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,

                                                  children: <Widget>[
                                                    Text('    OIL 총점수:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 18,
                                                            color: Colors
                                                                .blueGrey)),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end,
                                                      children: [
                                                        Container(
                                                          height: 45,
                                                          width: 150,
                                                          decoration: BoxDecoration(
                                                              color: getColor(snapshot.data.oilScore),
                                                              shape: BoxShape.rectangle,
                                                              borderRadius: BorderRadius.circular(8.0)),
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                            Text(getUpDownString(snapshot.data.oilScore),
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20,
                                                                  color: Colors.white,
                                                                )),
                                                            Text('${snapshot.data.oilScore} ',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 24,
                                                                  color: Colors.white,
                                                                )),
                                                          ]),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ],
                                          ))),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(12, 2, 2, 0),
                                height: 190,
                                width: 390,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 3.0,
                                                        right: 3.0),
                                                    child: Align(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Image.asset(
                                                          'images/exc.png',
                                                          height: 120,
                                                          width: 140),
                                                    ),
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text('기준가:',
                                                                  style:
                                                                  TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16,
                                                                    color: Colors.black38,
                                                                  ),

                                                                ),
                                                                Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .centerRight,
                                                                  child:
                                                                  Text(
                                                                    getNumberWithComma(snapshot.data.bfStdRate),
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: Colors.black54),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(' 종   가:',
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 16,
                                                                        color: Colors.black38)),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Text(
                                                                      getNumberWithComma(snapshot.data.tdOpRate),
                                                                      textAlign:
                                                                      TextAlign.end,
                                                                      style: TextStyle(
                                                                          fontSize: 20,
                                                                          color: Colors.black54),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 185,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Stack(
                                                                      children: <Widget>[
                                                                        Text(
                                                                          '${snapshot.data.excDiffRate}%[ '+getNumberWithComma(snapshot.data.excDiffPrice)+'] ',
                                                                          textAlign:
                                                                          TextAlign.end,
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: getColor(snapshot.data.excDiffRate)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          color: Colors.white38,
                                                          height: 3,
                                                          width: 185,
                                                          child: Table(border: TableBorder(
                                                            bottom: BorderSide(
                                                              color: Colors.black12,
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
                                                          ),
                                                        ),
                                                      ]),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 20),
                                                child:Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,

                                                  children: <Widget>[
                                                    Text('      환율 점수:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 18,
                                                            color: Colors
                                                                .blueGrey)),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end,
                                                      children: [
                                                        Container(
                                                          height: 45,
                                                          width: 140,
                                                          decoration: BoxDecoration(
                                                              color: getColor(snapshot.data.excScore1st),
                                                              shape: BoxShape.rectangle,
                                                              borderRadius: BorderRadius.circular(8.0)),
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                            Text(getUpDownString(snapshot.data.excScore1st),
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20,
                                                                  color: Colors.white,
                                                                )),
                                                            Text('${snapshot.data.excScore1st} ',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 24,
                                                                  color: Colors.white,
                                                                )),
                                                          ]),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ],
                                          ))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.white38,
                              height: 41,
                              width: 217,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' 투자 점수[등급] ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2.0,
                                          color: Colors.blueGrey)),
                                ]
                            ),
                          ],
                        ),
                        Container(
                          color: Colors.white38,
                          height: 3,
                          width: 380,
                          child: Table(border: TableBorder(
                            bottom: BorderSide(
                              color: Colors.blueGrey,
                              style: BorderStyle.solid,
                              width: 2.0,
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
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.all(10),
                            width: 380,
                            child: Card(
                              elevation: 3,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3, top: 5,right: 10),
                                  child:   Table(
                            // columnWidths: ,
                            border: TableBorder(
                              bottom: BorderSide(
                                style: BorderStyle.none,
                              ),
                              horizontalInside: BorderSide(
                                color: Colors.black12,
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
                                color: Colors.black12,
                                style: BorderStyle.solid,
                                width: 1.0,
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
                                      Text('환율 제외',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54)),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('＄/￦환율',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54)),
                                    ]),
                              ]),
                              TableRow(children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          getUpDownString(snapshot.data.exRauTotScore) + '${snapshot.data.exRauTotScore}[${snapshot.data.exRauTotScoreGrade}] ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight:
                                              FontWeight.bold,
                                              color: getColor(snapshot
                                                  .data.exRauTotScore))),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          //' $_excScore1st [$_excSetRngGrp]',
                                          getUpDownString(snapshot.data.excScore1st) + '${snapshot.data.excScore1st}[${snapshot.data.excSetRngGrp}] ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight:
                                              FontWeight.bold,
                                              color: getColor(
                                                  snapshot.data.excScore1st))),
                                    ]),
                              ]),
                            ],
                          ),)))
                        ),
                        SizedBox(height: 20),
                        Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.white38,
                              height: 41,
                              width: 217,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' 투자 추천 ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2.0,
                                          color: Colors.blueGrey)),
                                ]
                            ),
                          ],
                        ),
                        Container(
                          color: Colors.white38,
                          height: 3,
                          width: 380,
                          child: Table(border: TableBorder(
                            bottom: BorderSide(
                              color: Colors.blueGrey,
                              style: BorderStyle.solid,
                              width: 2.0,
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
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(12, 2, 2, 0),
                          height: 140,
                          width: 380,
                          child: Card(
                            elevation: 3,
                            child: Padding(
                                padding: EdgeInsets.all(2),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  left: 3.0,
                                                  right: 3.0),
                                              child: Align(
                                                alignment: Alignment
                                                    .centerLeft,
                                                child: getImage(snapshot.data.selectStock, snapshot.data.otType, 1),
                                              ),
                                            ),
                                            Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  Container(
                                                    width: 225,
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Icon(
                                                            Icons.looks_one,
                                                            size: 36,
                                                            color: Colors.black87,
                                                          ),
                                                          Text('순위',
                                                            style:
                                                            TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              color: Colors.black38,
                                                            ),

                                                          ),
                                                        ]),
                                                  ),
                                                  Container(
                                                    color: Colors.white38,
                                                    height: 3,
                                                    width: 225,
                                                    child: Table(border: TableBorder(
                                                      bottom: BorderSide(
                                                        color: Colors.black12,
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
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 225,
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('매수예약(%):',
                                                            style:
                                                            TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                              color: Colors.black38,
                                                            ),

                                                          ),
                                                          Align(
                                                            alignment:
                                                            Alignment
                                                                .centerRight,
                                                            child:
                                                            Text(
                                                              getUpDownString(snapshot.data.buyRate1st) + getBuyRate(snapshot.data.buyRate1st, snapshot.data.excScore1st),
                                                              textAlign: TextAlign.end,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: getColor(
                                                                      snapshot.data.buyRate1st)),
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                  Container(
                                                    color: Colors.white38,
                                                    height: 3,
                                                    width: 225,
                                                    child: Table(border: TableBorder(
                                                      bottom: BorderSide(
                                                        color: Colors.black12,
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
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 225,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('       손절(%):',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16,
                                                                  color: Colors.black38)),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Text(
                                                                getUpDownString(snapshot.data.minusDecide1st) + '${snapshot.data.minusDecide1st}% ',
                                                                textAlign:
                                                                TextAlign.end,
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    color: getColor(snapshot
                                                                        .data.minusDecide1st)),
                                                              ),
                                                            ],
                                                          ),
                                                        ]),
                                                  ),
                                                  Container(
                                                    color: Colors.white38,
                                                    height: 3,
                                                    width: 225,
                                                    child: Table(border: TableBorder(
                                                      bottom: BorderSide(
                                                        color: Colors.black12,
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
                                                    ),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ],
                                    ))),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.fromLTRB(12, 2, 2, 0),
                          height: 140,
                          width: 380,
                          child: Card(
                            elevation: 3,
                            child: Padding(
                                padding: EdgeInsets.all(2),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  left: 3.0,
                                                  right: 3.0),
                                              child: Align(
                                                alignment: Alignment
                                                    .centerLeft,
                                                child: getImage(snapshot.data.selectStock, snapshot.data.otType, 2),
                                              ),
                                            ),
                                            Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  Container(
                                                    width: 225,
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Icon(
                                                            Icons.looks_two,
                                                            size: 36,
                                                            color: Colors.black87,
                                                          ),
                                                          Text('순위',
                                                            style:
                                                            TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              color: Colors.black38,
                                                            ),

                                                          ),
                                                        ]),
                                                  ),
                                                  Container(
                                                    color: Colors.white38,
                                                    height: 3,
                                                    width: 225,
                                                    child: Table(border: TableBorder(
                                                      bottom: BorderSide(
                                                        color: Colors.black12,
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
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 225,
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('매수예약(%):',
                                                            style:
                                                            TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                              color: Colors.black38,
                                                            ),

                                                          ),
                                                          Align(
                                                            alignment:
                                                            Alignment
                                                                .centerRight,
                                                            child:
                                                            Text(
                                                              getUpDownString(snapshot.data.buyRate2nd) + '${snapshot.data.buyRate2nd}% ',
                                                              textAlign: TextAlign.end,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: getColor(snapshot
                                                                      .data.buyRate2nd)),
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                  Container(
                                                    color: Colors.white38,
                                                    height: 3,
                                                    width: 225,
                                                    child: Table(border: TableBorder(
                                                      bottom: BorderSide(
                                                        color: Colors.black12,
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
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 225,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text('       손절(%):',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16,
                                                                  color: Colors.black38)),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Text(
                                                                getUpDownString(snapshot.data.minusDecide2nd) + '${snapshot.data.minusDecide2nd}% ',
                                                                textAlign:
                                                                TextAlign.end,
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    color: getColor(snapshot
                                                                        .data.minusDecide2nd)),
                                                              ),
                                                            ],
                                                          ),
                                                        ]),
                                                  ),
                                                  Container(
                                                    color: Colors.white38,
                                                    height: 3,
                                                    width: 225,
                                                    child: Table(border: TableBorder(
                                                      bottom: BorderSide(
                                                        color: Colors.black12,
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
                                                    ),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ],
                                    ))),
                          ),
                        ),
                        SizedBox(height: 5),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Text("   ※매수예약은 종목의 시작가 대비(%)입니다.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  letterSpacing: 2.0,
                                ))),
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
                                            '장 시작 후 시장 조회를 하셔야합니다!'),
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
                                          return Padding(
                                              padding: new EdgeInsets.only(bottom:110.0),
                                              child: DibrEtfStockInfoPage(marketInfo: marketInfo));
                                        }
                                    ));
                                  }
                                },
                              ),)),
                        SizedBox(height: 50),
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
          padding: const EdgeInsets.only(bottom: 5.0),
          child: FloatingActionButton.extended(
              label: Text(
                '시장 정보 조회',
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
              backgroundColor: Colors.purpleAccent,
              onPressed: () {
                print("_selectedDay:");
                print(_selectedDay);
                print("chkHoliday(_selectedDtHh) ");
                print(chkHoliday(_selectedDtHh) );
                if(_selectedDay == 7 || _selectedDay == 6) {
                  print(exRtScore.abs());
                  showDialog(
                    context: context,
                    builder: (context)
                    {
                      return AlertDialog(
                        title: Text('[Info]'),
                        content: Text(
                            '주말은 조회가 불가능합니다!'),
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
                  if(chkHoliday(_selectedDtHh) == 'Y'){
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('[Info]'),
                            content: Text('휴장일은 조회가 불가능합니다!'),
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
                  }

                }
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
