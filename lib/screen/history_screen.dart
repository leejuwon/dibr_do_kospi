import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import "package:flutter_dibr_do_kospi/ad_manager.dart";
import "package:flutter_dibr_do_kospi/screen/result_screen.dart";
import "package:flutter_dibr_do_kospi/main.dart";
import "package:flutter_dibr_do_kospi/model/model_market.dart";
import "package:flutter_dibr_do_kospi/model/model_etfStock.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DibrHistoryPage extends StatefulWidget {
  @override
  _DibrHistoryPageState createState() => _DibrHistoryPageState();
}

class _DibrHistoryPageState extends State<DibrHistoryPage> {
  Future<MarketInfo> futureHistMarketInfo;
  Future<List<EtfStockInfo>> futureHistEtfStockInfo;

  EtfItem selectedEtf;
  List<EtfItem> etfStocks = <EtfItem>[
    const EtfItem(
        'KDX',
        'KODEX',
        Icon(
          Icons.check_circle_outline,
          color: Colors.redAccent,
        )),
    const EtfItem(
        'TGR',
        'TIGER',
        Icon(
          Icons.check_circle_outline,
          color: Colors.deepOrangeAccent,
        )),
    const EtfItem(
        'KSF',
        'KOSEF',
        Icon(
          Icons.check_circle_outline,
          color: Colors.yellowAccent,
        )),
    const EtfItem(
        'KBS',
        'KBSTAR',
        Icon(
          Icons.check_circle_outline,
          color: Colors.greenAccent,
        )),
    const EtfItem(
        'ARR',
        'ARRIRANG',
        Icon(
          Icons.check_circle_outline,
          color: Colors.blueAccent,
        )),
    const EtfItem(
        'KSP',
        'KOSPI',
        Icon(
          Icons.check_circle_outline,
          color: Colors.indigoAccent,
        )),
  ];

  //DateTime now = DateTime.now();

  String _selectedDt = new DateFormat("yyyy-MM-dd").format(new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));

  String _selectedEtf;

  //String _selectedDt = new DateFormat("yyyy-MM-dd").format(DateTime.now());

  bool _isHistRewardedAdReady;

  @override
  void initState() {
    super.initState();

    // TODO: Set Rewarded Ad event listener
    RewardedVideoAd.instance.listener = _onHistRewardedAdEvent;

    // TODO: Load a Rewarded Ad
    futureHistMarketInfo = fetchMarketHistInfo('Init');
    futureHistEtfStockInfo = fetchEtfInfo('Init');
  }

  // TODO: Implement _onRewardedAdEvent()
  void _onHistRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          _isHistRewardedAdReady = true;
        });
        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          _isHistRewardedAdReady = false;
        });
        RewardedVideoAd.instance.load(
          targetingInfo: MobileAdTargetingInfo(),
          adUnitId: AdManager.rewardedAdUnitId,
        );
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          _isHistRewardedAdReady = true;
          futureHistMarketInfo = fetchMarketHistInfo('Hist');
        });
        print('Failed to load a rewarded ad');
        break;
      case RewardedVideoAdEvent.rewarded:
        print('@@@@@rewarded!!!!');
        setState(() {
          futureHistMarketInfo = fetchMarketHistInfo('Hist');
        });
        break;
      default:
      // do nothing
    }
  }

  // TODO: Implement _onRewardedAdEvent()
  void _onHistEtfRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    print('*****************HistEtfRewardedAdEvent rewarded!!!!');
    print(event);
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          _isHistRewardedAdReady = true;
        });
        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          _isHistRewardedAdReady = false;
        });
        RewardedVideoAd.instance.load(
          targetingInfo: MobileAdTargetingInfo(),
          adUnitId: AdManager.rewardedAdUnitId,
        );
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          _isHistRewardedAdReady = true;
          futureHistEtfStockInfo = fetchEtfInfo('Hist');
        });
        print('Failed to load a rewarded ad');
        break;
      case RewardedVideoAdEvent.rewarded:
        print('@@@@@rewarded!!!!');
        setState(() {
          futureHistEtfStockInfo = fetchEtfInfo('Hist');
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

  Image getImage(pType) {
    if (pType == null || pType == 'undefined') {
      pType = 'KDX_LVG';
    }

    if (pType == 'KDX_LVG') {
      return Image.asset('images/leverage_logo.png', height: 70, width: 70);
    } else if (pType == 'KDX_I2X') {
      return Image.asset('images/inverse_logo.png', height: 70, width: 70);
    } else {
      return Image.asset('images/leverage_logo.png', height: 70, width: 70);
    }
  }

  Future<MarketInfo> fetchMarketHistInfo(pType) async {
    print('fetchMarketHistInfo!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!pType: ' +
        pType);
    if (pType == 'Init') {
      print("1####################################~~~");
      return MarketInfo.fromInitJson();
    } else {
      final response = await http.get(Uri.encodeFull(
          'http://dibr.cafe24app.com/marketInfo/getMarketInfoHistDay/${_selectedDt}'));
      //headers: {"Accept": "application/json"});

      print(
          '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!_selectedDt: ' + _selectedDt);
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!pType: ' + pType);
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

  Future<List<EtfStockInfo>> fetchEtfInfo(pType) async {
    List<EtfStockInfo> rtnEtfStocks = [];

    print('@@@@@@@@@@@@@@@@@@@@fetchEtfInfo실행!!!??:' + pType);
    if (pType == 'Init') {
      print('pType:' + pType);
      //return EtfStockInfo.fromInitJson();
      rtnEtfStocks.add(EtfStockInfo.fromInitJson());
      rtnEtfStocks.add(EtfStockInfo.fromInitJson());
      return rtnEtfStocks;
    } else {
      rtnEtfStocks = [];
      print('@@@@@@@@@@@@@@@@@@@@로드?? ${_selectedDt}  ${_selectedEtf}');
      final response = await http.get(Uri.encodeFull(
          'http://dibr.cafe24app.com/marketInfo/getSelectedEtfInfo/${_selectedDt}/${_selectedEtf}'));
      //headers: {"Accept": "application/json"});
      print("상태####################################???????????");
      print(jsonDecode(response.body));
      print("상태####################################");
      print(response.statusCode);
      if (response.statusCode == 200) {
        List dataList = jsonDecode(response.body);
        var dataLength = dataList.length;
        Map dataJson;
        var dataStock;
        print("개수####################################");
        print(dataLength);
        if (dataLength == 2) {
          for (var etfStock in dataList) {
            //etfStocks.add(etfStock);
            //dataJson = etfStock;
            dataStock = EtfStockInfo.fromJson(etfStock);
            print("1####################################");
            print(dataStock);
            print(etfStock);
            print("2####################################");
            rtnEtfStocks.add(dataStock);
          }
        } else if (dataLength == 1) {
          dataJson = dataList[0];
          dataStock = EtfStockInfo.fromJson(dataJson);
          rtnEtfStocks.add(dataStock);
          rtnEtfStocks.add(EtfStockInfo.fromInitJson());
        } else if (dataLength == 0) {
          rtnEtfStocks.add(EtfStockInfo.fromInitJson());
          rtnEtfStocks.add(EtfStockInfo.fromInitJson());
        } else {
          rtnEtfStocks.add(EtfStockInfo.fromInitJson());
          rtnEtfStocks.add(EtfStockInfo.fromInitJson());
        }

        print("199####################################");
        print(rtnEtfStocks);
        print(rtnEtfStocks[0].etfStockId);
        print(rtnEtfStocks[1].etfStockId);
        print("299####################################");
        //var marketInfo = ;
        return rtnEtfStocks;
      } else {
        throw Exception('Failed to load MarketInfo');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    return Scaffold(
        body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
          SizedBox(height: 10),
          Stack(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'images/backgr2.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                      Widget>[
                    Container(
                      child: Image.asset(
                        'images/bg11.png',
                        height: 55,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                    ),
                    Container(
                      height: 55,
                      decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1.0, color: Colors.white),
                            left: BorderSide(width: 1.0, color: Colors.white),
                            right: BorderSide(width: 1.0, color: Colors.white),
                            bottom: BorderSide(width: 1.0, color: Colors.white),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            InkWell(
                              child: Text('$_selectedDt',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                Future<DateTime> selectedDate = showDatePicker(
                                  context: context,
                                  initialDate: new DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day - 1),
                                  firstDate: new DateTime(2000, 1, 1),
                                  lastDate: new DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day - 1),
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                        data: ThemeData.dark(), child: child);
                                  },
                                );

                                selectedDate.then((dateTime) {
                                  setState(() {
                                    var vDt = new DateFormat("yyyy-MM-dd")
                                        .format(dateTime);
                                    //_selectedTime = vDt;
                                    print('vDt:' + vDt);
                                    _selectedDt = vDt;
                                  });
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              tooltip: 'Tap to open date picker',
                              onPressed: () {
                                Future<DateTime> selectedDate = showDatePicker(
                                  context: context,
                                  initialDate: new DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day - 1),
                                  firstDate: new DateTime(2000, 1, 1),
                                  lastDate: new DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day - 1),
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                        data: ThemeData.dark(), child: child);
                                  },
                                );

                                selectedDate.then((dateTime) {
                                  setState(() {
                                    /*var vYear = dateTime.year;
                                    var vMonth = dateTime.month;
                                    var vDay = dateTime.day;*/

                                    //_selectedTime = dateTime;
                                    var vDt = new DateFormat("yyyy-MM-dd")
                                        .format(dateTime);
                                    print('vDt2: ' + vDt);
                                    _selectedDt = vDt;
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Stack(
            children: <Widget>[
              Container(
                color: Colors.black,
                height: 41,
                width: 240,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(' ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      fontStyle: FontStyle.normal,
                      backgroundColor: Colors.green,
                      letterSpacing: 2.0,
                    )),
                Text(' History 시장 정보 ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 2.0,
                        color: Colors.yellowAccent)),
              ]),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
              stream: futureHistMarketInfo.asStream(),

              builder: (BuildContext context, snapshot) {
                print('snapshot~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                print(snapshot);
                if (snapshot.hasData) {
                  print('snp~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                  print(snapshot);
                  print('snp~~~~~~~~~~~~~~~~~~~~~~~~~~~');

                  return Container(
                    margin: EdgeInsets.all(3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 190,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
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
                                                              height: 70,
                                                              width: 70),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.snpStdPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.snpEndPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .snpUdRateRealByClose),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .snpUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.snpUdRateRealByClose}%[${snapshot.data.snpUdPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.snpUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,

                                                    children: <Widget>[
                                                      Text('S&P500 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(
                                                                snapshot.data
                                                                    .snpScore),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .snpScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.snpScore} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .snpScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              )],
                                              ))),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 190,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
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
                                                              height: 70,
                                                              width: 70),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.eurStdPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.eurEndPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .eurUdRateRealByClose),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .eurUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.eurUdRateRealByClose}%[${snapshot.data.eurUdPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.eurUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('EURO50 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(
                                                                snapshot.data
                                                                    .eurScore),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .eurScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.eurScore} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .eurScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                              )],
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 190,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
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
                                                              height: 70,
                                                              width: 70),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.wtiStdPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.wtiEndPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .wtiUdRateRealByClose),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .wtiUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.wtiUdRateRealByClose}%[${snapshot.data.wtiUdPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.wtiUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('WTI 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(
                                                                snapshot.data
                                                                    .wtiScore),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .wtiScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.wtiScore} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .wtiScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              )],
                                              ))),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 190,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
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
                                                              height: 70,
                                                              width: 70),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.dubStdPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.dubEndPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .dubUdRateRealByClose),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .dubUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.dubUdRateRealByClose}%[${snapshot.data.dubUdPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.dubUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('Dubai 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(
                                                                snapshot.data
                                                                    .dubScore),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .dubScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.dubScore} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .dubScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                              )],
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 190,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
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
                                                              height: 70,
                                                              width: 70),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.breStdPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.breEndPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .breUdRateRealByClose),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .breUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.breUdRateRealByClose}%[${snapshot.data.breUdPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.breUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('Brent 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(
                                                                snapshot.data
                                                                    .breScore),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .breScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.breScore} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .breScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              )],
                                              ))),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 190,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
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
                                                              'images/excnew_logo.png',
                                                              height: 70,
                                                              width: 70),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.bfStdRate} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.tdOpRate} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .excDiffRate),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .excDiffRate),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.excDiffRate}%[${snapshot.data.excDiffPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.excDiffRate)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('환율 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(snapshot
                                                                .data
                                                                .excScore1st),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .excScore1st),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.excScore1st} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .excScore1st)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                              )],
                                              ))),
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
                              width: 238,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        fontStyle: FontStyle.normal,
                                        backgroundColor: Colors.green,
                                        letterSpacing: 2.0,
                                      )),
                                  Text('    투자 점수[등급]   ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2.0,
                                          color: Colors.yellowAccent)),
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
                              width: 235,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        fontStyle: FontStyle.normal,
                                        backgroundColor: Colors.green,
                                        letterSpacing: 2.0,
                                      )),
                                  Text('        투자 추천       ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2.0,
                                          color: Colors.yellowAccent)),
                                ]),
                          ],
                        ),
                        SizedBox(height: 10),
                        Table(
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
                                      Icons.priority_high,
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
                                      color: getColor(snapshot.data.buyRate1st),
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
                                            color: getColor(
                                                snapshot.data.minusDecide1st))),
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
                                      color: getColor(snapshot.data.buyRate2nd),
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
                                            color: getColor(
                                                snapshot.data.minusDecide2nd))),
                                  ]),
                            ]),
                          ],
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
          Container(
            margin: EdgeInsets.all(10),
            child: StreamBuilder(
                stream: futureHistEtfStockInfo.asStream(),
                builder: (BuildContext context, snapshot) {
                  print('snapshot~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                  print(snapshot);
                  if (snapshot.hasData) {
                    final etfDb = snapshot.data;
                    print('~~~~~etfDb~~~~~');
                    print(snapshot.data.length);
                    for (var item in etfDb) {
                      print(item.etfStockName);
                      print(item.etfStockDate);
                      print(item.etfBefClosePrice);
                    }

                    List<Card> etfStockCardList = [];

                    /*for( var etfStock in etfDb){

	//etfStockCardList.add(etfStock);
  }*/
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Container(
                          child: Image.asset(
                            'images/pic_g.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DropdownButton<EtfItem>(
                                hint: Text("ETF 종목을 선택해주세요."),
                                value: selectedEtf,
                                onChanged: (EtfItem Value) {
                                  setState(() {
                                    selectedEtf = Value;
                                    _selectedEtf = Value.id;
                                  });
                                },
                                items: etfStocks.map((EtfItem user) {
                                  return DropdownMenuItem<EtfItem>(
                                    value: user,
                                    child: Row(
                                      children: <Widget>[
                                        user.icon,
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          user.name,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              FlatButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.all(8.0),
                                splashColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                onPressed: () {
                                  print(exRtScore.abs());
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Need a StockInfo?'),
                                        content: Text(
                                            'Watch an Ad to get a information!'),
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
                                              RewardedVideoAd
                                                      .instance.listener =
                                                  _onHistEtfRewardedAdEvent;
                                              Navigator.pop(context);
                                              RewardedVideoAd.instance.show();
                                              //RestApi_Get();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.movie,
                                      size: 25,
                                    ),
                                    Text(
                                      "(Ad)ETF 정보 조회",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.blue,
                              height: 41,
                              width: 236,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        fontStyle: FontStyle.normal,
                                        backgroundColor: Colors.orange,
                                        letterSpacing: 2.0,
                                      )),
                                  Text('    ETF 투자 결과    ',
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
                          margin: EdgeInsets.all(2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                height: 120,
                                width: 190,
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3, top: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3.0,
                                                            right: 3.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: getImage(snapshot
                                                          .data[0].etfStockId),
                                                    ),
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text('기준가:',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .green)),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Text(
                                                                    '${snapshot.data[0].etfBefClosePrice} ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text('종가:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .green)),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    '${snapshot.data[0].etfClosePrice} ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Icon(
                                                                    getUpDownIcon(snapshot
                                                                        .data[0]
                                                                        .etfTodayDiffPrice),
                                                                    size: 14,
                                                                    color: getColor(snapshot
                                                                        .data[0]
                                                                        .etfTodayDiffPrice),
                                                                  ),
                                                                  Text(
                                                                    '${snapshot.data[0].etfUdRateRealByToday}%[${snapshot.data[0].etfTodayDiffPrice}] ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            11,
                                                                        color: getColor(snapshot
                                                                            .data[0]
                                                                            .etfTodayDiffPrice)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                      ]),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('편차 점수:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color:
                                                              Colors.black87)),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        getUpDownIcon(snapshot
                                                            .data[0]
                                                            .etfTodayDiffPrice),
                                                        size: 24,
                                                        color: getColor(snapshot
                                                            .data[0]
                                                            .etfTodayDiffPrice),
                                                      ),
                                                      Text(
                                                        '${snapshot.data[0].etfTodayDiffPrice} ',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                            color: getColor(snapshot
                                                                .data[0]
                                                                .etfTodayDiffPrice)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ))),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                height: 120,
                                width: 190,
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3, top: 5),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3.0,
                                                            right: 3.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: getImage(snapshot
                                                          .data[1].etfStockId),
                                                    ),
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text('기준가:',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .green)),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Text(
                                                                    '${snapshot.data[1].etfBefClosePrice} ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text('종가:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .green)),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    '${snapshot.data[1].etfClosePrice} ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Icon(
                                                                    getUpDownIcon(snapshot
                                                                        .data[1]
                                                                        .etfTodayDiffPrice),
                                                                    size: 14,
                                                                    color: getColor(snapshot
                                                                        .data[1]
                                                                        .etfTodayDiffPrice),
                                                                  ),
                                                                  Text(
                                                                    '${snapshot.data[1].etfUdRateRealByToday}%[${snapshot.data[1].etfTodayDiffPrice}] ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            11,
                                                                        color: getColor(snapshot
                                                                            .data[1]
                                                                            .etfTodayDiffPrice)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                      ]),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('편차 점수:',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color:
                                                              Colors.black87)),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        getUpDownIcon(snapshot
                                                            .data[1]
                                                            .etfTodayDiffPrice),
                                                        size: 24,
                                                        color: getColor(snapshot
                                                            .data[1]
                                                            .etfTodayDiffPrice),
                                                      ),
                                                      Text(
                                                        '${snapshot.data[1].etfTodayDiffPrice} ',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                            color: getColor(snapshot
                                                                .data[1]
                                                                .etfTodayDiffPrice)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 300),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    print('error!');
                    print("${snapshot.error}");
                    return Text("${snapshot.error}");
                  }

                  return CircularProgressIndicator();
                }),
          ),
        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 48.0),
          child: FloatingActionButton.extended(
              label: Text(
                '(Ad)시장 정보 조회)',
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
              backgroundColor: Colors.orange,
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
                            // TODO: Set Rewarded Ad event listener
                            RewardedVideoAd.instance.listener =
                                _onHistRewardedAdEvent;
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
