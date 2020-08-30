import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import "package:flutter_dibr_do_kospi/ad_manager.dart";
import "package:flutter_dibr_do_kospi/main.dart";
import "package:flutter_dibr_do_kospi/model/model_etfStock.dart";
import "package:flutter_dibr_do_kospi/model/model_market.dart";
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DibrEtfStockInfoPage extends StatefulWidget {
  final MarketInfo marketInfo;

  DibrEtfStockInfoPage({this.marketInfo});

  @override
  _DibrEtfStockInfoPageState createState() => _DibrEtfStockInfoPageState();
}

class _DibrEtfStockInfoPageState extends State<DibrEtfStockInfoPage> {
  Future<List<EtfStockInfo>> futureHistEtfStockInfo;
  String _selectedDt = "";
  String _selectedEtf;
  String _selectedExTotGrade;
  String _selectedExcSetGrade;
  String _selectedParentScreen;
  String _selectedDtHh;
  String _selectedHh;
  String _selectedMm;
  MarketInfo _marketInfo;

  bool _isHistRewardedAdReady;

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

  @override
  void initState() {
    super.initState();

    _marketInfo = widget.marketInfo;

    // TODO: Set Rewarded Ad event listener
    RewardedVideoAd.instance.listener = _onHistEtfRewardedAdEvent;

    // TODO: Load a Rewarded Ad
    futureHistEtfStockInfo = fetchEtfInfo('Init');
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
      pType = 'L';
    }

    if (pType == 'L') {
      return Image.asset('images/leverage_logo_2.png', height: 120, width: 90);
    } else if (pType == 'I') {
      return Image.asset('images/inverse_logo_2.png', height: 120, width: 90);
    } else {
      return Image.asset('images/leverage_logo_2.png', height: 120, width: 90);
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
      print(
          '@@@@@@@@@@@@@@@@@@@@로드?? ${_marketInfo.kspStockDate}  ${_selectedEtf} ${_marketInfo.selectStock} ${_marketInfo.buyRate1st}  ${_marketInfo.buyRate2nd}');
      final response = await http.get(Uri.encodeFull(
          'http://dibr.cafe24app.com/marketInfo/getSelectedEtfInfo/${_marketInfo.selectStock}/${_marketInfo.buyRate1st}/${_marketInfo.buyRate2nd}/${_marketInfo.kspStockDate}/${_selectedEtf}'));
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
                'images/etf_bg_1.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 150),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                              right:
                                  BorderSide(width: 1.0, color: Colors.white),
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.white),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              InkWell(
                                child: Text('${_marketInfo.kspStockDate}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white)),
                                onTap: () {},
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
              Text(' KOSPI ETF 정보 ',
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
        Container(
          margin: EdgeInsets.all(3),
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
                              color: Colors.teal,
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
                                            RewardedVideoAd.instance.listener =
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
                                Text('    ETF Stock 정보    ',
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
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("당일 마감정보는 4시 이후에 확인이 가능합니다.",
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                letterSpacing: 2.0,
                              ))),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.all(2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                height: 300,
                                width: 440,
                                child: Card(
                                    elevation: 5,
                                    child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3, top: 5),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 3.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: getImage(snapshot
                                                          .data[0]
                                                          .etfStockType),
                                                    ),
                                                  ),
                                                  Table(
                                                    // columnWidths: ,
                                                    border: TableBorder(
                                                      bottom: BorderSide(
                                                        color: Colors.blueGrey,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 1.0,
                                                      ),
                                                      horizontalInside:
                                                          BorderSide(
                                                        color: Colors.white,
                                                        style:
                                                            BorderStyle.solid,
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
                                                      verticalInside:
                                                          BorderSide(
                                                        style: BorderStyle.none,
                                                      ),
                                                    ),
                                                    //defaultColumnWidth: FixedColumnWidth(60.0),
                                                    columnWidths: {
                                                      0: FixedColumnWidth(50.0),
                                                      1: FixedColumnWidth(90.0),
                                                      2: FixedColumnWidth(55.0),
                                                      3: FixedColumnWidth(95.0),
                                                    },

                                                    children: [
                                                      TableRow(children: [
                                                        Text('종목명:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .green)),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                '${snapshot.data[0].etfStockName} ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ]),
                                                        Text('  기준가:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .green)),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                  '${snapshot.data[0].etfBefClosePrice} ',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .black)),
                                                            ]),
                                                      ]),
                                                      TableRow(children: [
                                                        Text('시가(%):\n ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .green)),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                '${snapshot.data[0].etfOpenPrice} ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 10,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Icon(
                                                                    getUpDownIcon(snapshot.data[0].etfUdRateRealByOpen),
                                                                    size: 12,
                                                                    color: getColor(snapshot.data[0].etfUdRateRealByOpen),
                                                                  ),
                                                                  Text(
                                                                    '${snapshot.data[0].etfUdRateRealByOpen}%[${snapshot.data[0].etfOpenPrice - snapshot.data[0].etfBefClosePrice}] ',
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 10,
                                                                        color: getColor(snapshot.data[0].etfUdRateRealByOpen)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                        Text('  종가(%):\n ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .green)),
                                                        Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
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
                                                                    fontSize: 10,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Icon(
                                                                    getUpDownIcon(snapshot.data[0].etfUdRateRealByClose),
                                                                    size: 12,
                                                                    color: getColor(snapshot.data[0].etfUdRateRealByClose),
                                                                  ),
                                                                  Text(
                                                                    '${snapshot.data[0].etfUdRateRealByClose}%[${snapshot.data[0].etfClosePrice - snapshot.data[0].etfBefClosePrice}] ',
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 10,
                                                                        color: getColor(snapshot.data[0].etfUdRateRealByClose)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                      ]),
                                                      TableRow(children: [
                                                        Text('고가(%):\n ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .green)),
                                                        Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                            children: [
                                                              Text(
                                                                '${snapshot.data[0].etfHighPrice} ',
                                                                textAlign:
                                                                TextAlign
                                                                    .end,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize: 10,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Icon(
                                                                    getUpDownIcon(snapshot.data[0].etfUdRateRealByHigh),
                                                                    size: 12,
                                                                    color: getColor(snapshot.data[0].etfUdRateRealByHigh),
                                                                  ),
                                                                  Text(
                                                                    '${snapshot.data[0].etfUdRateRealByHigh}%[${snapshot.data[0].etfHighPrice - snapshot.data[0].etfBefClosePrice}] ',
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 10,
                                                                        color: getColor(snapshot.data[0].etfUdRateRealByHigh)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                        Text('  저가(%):\n ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .green)),
                                                        Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                            children: [
                                                              Text(
                                                                '${snapshot.data[0].etfLowPrice} ',
                                                                textAlign:
                                                                TextAlign
                                                                    .end,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize: 10,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Icon(
                                                                    getUpDownIcon(snapshot.data[0].etfUdRateRealByLow),
                                                                    size: 12,
                                                                    color: getColor(snapshot.data[0].etfUdRateRealByLow),
                                                                  ),
                                                                  Text(
                                                                    '${snapshot.data[0].etfUdRateRealByLow}%[${snapshot.data[0].etfLowPrice - snapshot.data[0].etfBefClosePrice}] ',
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 10,
                                                                        color: getColor(snapshot.data[0].etfUdRateRealByLow)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                      ]),
                                                    ],
                                                  ),
                                                ]),Table(
                                                  // columnWidths: ,
                                                  border: TableBorder(
                                                    bottom: BorderSide(
                                                      color: Colors.blueGrey,
                                                      style:
                                                      BorderStyle.solid,
                                                      width: 1.0,
                                                    ),
                                                    horizontalInside:
                                                    BorderSide(
                                                      color: Colors.white,
                                                      style:
                                                      BorderStyle.solid,
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
                                                    verticalInside:
                                                    BorderSide(
                                                      style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  //defaultColumnWidth: FixedColumnWidth(60.0),
                                                  columnWidths: {
                                                    0: FixedColumnWidth(90.0),
                                                    1: FixedColumnWidth(90.0),
                                                    2: FixedColumnWidth(80.0),
                                                    3: FixedColumnWidth(100.0),
                                                  },

                                                  children: [
                                                    TableRow(children: [
                                                      Text('  예약가(%):\n ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal)),
                                                      Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[0].etfRsvBuyPrc} [${snapshot.data[0].etfRsvBuyRate}%]',
                                                              textAlign:
                                                              TextAlign
                                                                  .end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize:
                                                                  16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ]),
                                                      Text('  손절(%):\n ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal)),
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                                '${_marketInfo.minusDecide1st} ',
                                                                textAlign:
                                                                TextAlign
                                                                    .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    color: Colors
                                                                        .black)),
                                                          ]),
                                                    ]),
                                                    TableRow(children: [
                                                      Text('  체결여부:\n ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal)),
                                                      Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[0].etfStockName} ',
                                                              textAlign:
                                                              TextAlign
                                                                  .end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize:
                                                                  16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ]),
                                                      Text('  수익(%):\n ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal)),
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                                '${snapshot.data[0].etfBefClosePrice} ',
                                                                textAlign:
                                                                TextAlign
                                                                    .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    color: Colors
                                                                        .black)),
                                                          ]),
                                                    ]),
                                                    TableRow(children: [
                                                      Text('  월누계(%):\n ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal)),
                                                      Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[0].etfStockName} ',
                                                              textAlign:
                                                              TextAlign
                                                                  .end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize:
                                                                  16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ]),
                                                      Text(' ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .green)),
                                                      Text(' ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .green)),
                                                    ]),
                                                  ],
                                                ),]))))),
                            Container(
                                padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                height: 300,
                                width: 430,
                                child: Card(
                                    elevation: 5,
                                    child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3, top: 5),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            right: 3.0),
                                                        child: Align(
                                                          alignment:
                                                          Alignment.centerLeft,
                                                          child: getImage(snapshot
                                                              .data[1]
                                                              .etfStockType),
                                                        ),
                                                      ),
                                                      Table(
                                                        // columnWidths: ,
                                                        border: TableBorder(
                                                          bottom: BorderSide(
                                                            color: Colors.blueGrey,
                                                            style:
                                                            BorderStyle.solid,
                                                            width: 1.0,
                                                          ),
                                                          horizontalInside:
                                                          BorderSide(
                                                            color: Colors.white,
                                                            style:
                                                            BorderStyle.solid,
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
                                                          verticalInside:
                                                          BorderSide(
                                                            style: BorderStyle.none,
                                                          ),
                                                        ),
                                                        //defaultColumnWidth: FixedColumnWidth(60.0),
                                                        columnWidths: {
                                                          0: FixedColumnWidth(50.0),
                                                          1: FixedColumnWidth(100.0),
                                                          2: FixedColumnWidth(55.0),
                                                          3: FixedColumnWidth(60.0),
                                                        },

                                                        children: [
                                                          TableRow(children: [
                                                            Text('종목명:',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .green)),
                                                            Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  Text(
                                                                    '${snapshot.data[1].etfStockName} ',
                                                                    textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        fontSize:
                                                                        10,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ]),
                                                            Text('  기준가:',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .green)),
                                                            Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  Text(
                                                                      '${snapshot.data[1].etfBefClosePrice} ',
                                                                      textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          10,
                                                                          color: Colors
                                                                              .black)),
                                                                ]),
                                                          ]),
                                                          TableRow(children: [
                                                            Text('시가(%):\n ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .green)),
                                                            Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  Text(
                                                                    '${snapshot.data[1].etfOpenPrice} ',
                                                                    textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        fontSize: 10,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot.data[1].etfUdRateRealByOpen),
                                                                        size: 12,
                                                                        color: getColor(snapshot.data[1].etfUdRateRealByOpen),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data[1].etfUdRateRealByOpen}%[${snapshot.data[1].etfOpenPrice - snapshot.data[1].etfBefClosePrice}] ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 10,
                                                                            color: getColor(snapshot.data[1].etfUdRateRealByOpen)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Text('  종가(%):\n ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize: 10,
                                                                    color: Colors
                                                                        .green)),
                                                            Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
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
                                                                        fontSize: 10,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot.data[1].etfUdRateRealByClose),
                                                                        size: 12,
                                                                        color: getColor(snapshot.data[1].etfUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data[1].etfUdRateRealByClose}%[${snapshot.data[1].etfClosePrice - snapshot.data[1].etfBefClosePrice}] ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 10,
                                                                            color: getColor(snapshot.data[1].etfUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                          TableRow(children: [
                                                            Text('고가(%):\n ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .green)),
                                                            Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  Text(
                                                                    '${snapshot.data[1].etfHighPrice} ',
                                                                    textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        fontSize: 10,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot.data[1].etfUdRateRealByHigh),
                                                                        size: 12,
                                                                        color: getColor(snapshot.data[1].etfUdRateRealByHigh),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data[1].etfUdRateRealByHigh}%[${snapshot.data[1].etfHighPrice - snapshot.data[1].etfBefClosePrice}] ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 10,
                                                                            color: getColor(snapshot.data[1].etfUdRateRealByHigh)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Text('  저가(%):\n ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .green)),
                                                            Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  Text(
                                                                    '${snapshot.data[1].etfLowPrice} ',
                                                                    textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        fontSize: 10,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot.data[1].etfUdRateRealByLow),
                                                                        size: 12,
                                                                        color: getColor(snapshot.data[1].etfUdRateRealByLow),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data[1].etfUdRateRealByLow}%[${snapshot.data[1].etfLowPrice - snapshot.data[1].etfBefClosePrice}] ',
                                                                        textAlign: TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 10,
                                                                            color: getColor(snapshot.data[1].etfUdRateRealByLow)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                        ],
                                                      ),
                                                    ]),Table(
                                                  // columnWidths: ,
                                                  border: TableBorder(
                                                    bottom: BorderSide(
                                                      color: Colors.blueGrey,
                                                      style:
                                                      BorderStyle.solid,
                                                      width: 1.0,
                                                    ),
                                                    horizontalInside:
                                                    BorderSide(
                                                      color: Colors.white,
                                                      style:
                                                      BorderStyle.solid,
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
                                                    verticalInside:
                                                    BorderSide(
                                                      style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  //defaultColumnWidth: FixedColumnWidth(60.0),
                                                  columnWidths: {
                                                    0: FixedColumnWidth(90.0),
                                                    1: FixedColumnWidth(90.0),
                                                    2: FixedColumnWidth(80.0),
                                                    3: FixedColumnWidth(100.0),
                                                  },

                                                  children: [
                                                    TableRow(children: [
                                                      Text('  예약가(%):\n ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal)),
                                                      Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[1].etfRsvBuyPrc} [${snapshot.data[1].etfRsvBuyRate}%]',
                                                              textAlign:
                                                              TextAlign
                                                                  .end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize:
                                                                  16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ]),
                                                      Text('  손절(%):\n ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal)),
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                                '${_marketInfo.minusDecide2nd} ',
                                                                textAlign:
                                                                TextAlign
                                                                    .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    color: Colors
                                                                        .black)),
                                                          ]),
                                                    ]),
                                                    TableRow(children: [
                                                      Text('  체결여부:\n ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal)),
                                                      Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[1].etfStockName} ',
                                                              textAlign:
                                                              TextAlign
                                                                  .end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize:
                                                                  16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ]),
                                                      Text('  수익(%):\n ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal)),
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                                '${snapshot.data[1].etfBefClosePrice} ',
                                                                textAlign:
                                                                TextAlign
                                                                    .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    color: Colors
                                                                        .black)),
                                                          ]),
                                                    ]),
                                                    TableRow(children: [
                                                      Text('  월누계(%):\n ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .teal)),
                                                      Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[1].etfStockName} ',
                                                              textAlign:
                                                              TextAlign
                                                                  .end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize:
                                                                  16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ]),
                                                      Text(' ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .green)),
                                                      Text(' ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .green)),
                                                    ]),
                                                  ],
                                                ),]))))),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                          height: 60,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: RaisedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.undo,
                                    size: 40.0,
                                    color: Colors.white,
                                  ),
                                  Text("돌아가기",
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.white)),
                                ],
                              ),
                              color: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(20.0)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )),
                      SizedBox(height: 300),
                    ],
                  );
                } else if (snapshot.hasError) {
                  print('error!');
                  print("${snapshot.error}");
                  return Text("${snapshot.error}");
                }

                return Text("오늘의 시장정보로 계산된 \n ETF 정보가 표시됩니다.",
                    style: TextStyle(fontSize: 24, color: Colors.blueGrey));
              }),
        ),
      ]),
    );
  }
}

class EtfItem {
  const EtfItem(this.id, this.name, this.icon);

  final String name;
  final String id;
  final Icon icon;
}
