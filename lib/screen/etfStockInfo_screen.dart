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
  String _selectedStdPrcTy;
  String _selectedStdPrcTyNm = " ";
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

  StdPrcTyItem selectedStdPrcTy;
  List<StdPrcTyItem> stdPrcTy = <StdPrcTyItem>[
    const StdPrcTyItem(
        'P1',
        '1000만원',
        Icon(
          Icons.check_circle_outline,
          color: Colors.redAccent,
        )),
    const StdPrcTyItem(
        'P3',
        '3000만원',
        Icon(
          Icons.check_circle_outline,
          color: Colors.deepOrangeAccent,
        )),
    const StdPrcTyItem(
        'P5',
        '5000만원',
        Icon(
          Icons.check_circle_outline,
          color: Colors.greenAccent,
        )),
  ];

  @override
  void initState() {
    super.initState();

    _marketInfo = widget.marketInfo;

    _selectedStdPrcTy = "P1";
    _selectedStdPrcTyNm = "1000만원";

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

  String getYn(pData) {
    if (pData == null || pData == 'undefined') {
      pData = 'N';
    }

    if (pData == 'N') {
      return "No";
    } else {
      return "Yes";
    }
  }

  String getBuyRate(pNum){
    if (pNum == null || pNum == 'undefined') {
      return "0.00% ";
    }else if (pNum == 0.0 || pNum == 0) {
      return "시작가 매수 ";
    }else{
      return pNum.toString() + '% ';
    }
  }

  String getStdPrcTp(pStdPrcTy, pPrc1st, pPrc2nd, pPrc3rd) {
    var rtnPrc = '';
    if (pStdPrcTy == null || pStdPrcTy == 'undefined') {
      rtnPrc = '0';
    }

    if (pStdPrcTy == 'P1') {
      rtnPrc = getNumberWithComma(pPrc1st);
    } else if (pStdPrcTy == 'P3') {
      rtnPrc = getNumberWithComma(pPrc2nd);
    } else if (pStdPrcTy == 'P5') {
      rtnPrc = getNumberWithComma(pPrc3rd);
    } else{
      rtnPrc = '0';
    }

    return rtnPrc;
  }

  String getNumberWithComma(pNum) {
    if (pNum == null || pNum == 'undefined') {
      return "0.00 ";
    } else {
      return new NumberFormat('###,###,###,###.##')
              .format(pNum)
              .replaceAll(' ', '') +
          " ";
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
      return Image.asset('images/leverage_logo_2.png', height: 100, width: 80);
    } else if (pType == 'I') {
      return Image.asset('images/inverse_logo_2.png', height: 100, width: 80);
    } else {
      return Image.asset('images/leverage_logo_2.png', height: 100, width: 80);
    }
  }

  String getSelectResultStock(pYn1st, pYn2nd, p1stNm, p2ndNm) {
    /****************************
     * 1순위가 체결되었으면 1순위 이름으로
     * 2순위가 체결되었으면 2순위 이름으로
     */
      if (pYn1st == "Y") {
        return p1stNm;
      }else{
        if (pYn1st == "Y") {
          return p2ndNm;
        }else {
          return " ";
        }
      }
  }


  String getConclYn(pYn1st, pYn2nd) {
    /****************************
     * 1순위가 체결되었으면 1순위 이름으로
     * 2순위가 체결되었으면 2순위 이름으로
     */
    if (pYn1st == "Y") {
      return "YES";
    }else{
      if (pYn1st == "Y") {
        return "YES";
      }else {
        return "NO";
      }
    }
  }

  String getStdPrcNm(pType) {
    if (pType == null || pType == 'undefined') {
      return " ";
    }else{
      return pType;
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
          'http://dibr2020.cafe24app.com/marketInfo/getSelectedEtfInfo/${_marketInfo.selectStock}/${_marketInfo.buyRate1st}/${_marketInfo.buyRate2nd}/${_marketInfo.kspStockDate}/${_selectedEtf}'));
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
            dataStock = null;
            dataStock = EtfStockInfo.fromJson(etfStock);
            //print("1####################################");
            //print(dataStock);
            //print(etfStock);
            //print("2####################################");
            rtnEtfStocks.add(dataStock);
            //rtnEtfStocks.add(dataStock);
            //print(rtnEtfStocks[0]);
            //print(rtnEtfStocks[1]);
          }
        } else if (dataLength == 1) {
          print("33####################################");
          dataJson = dataList[0];
          dataStock = EtfStockInfo.fromJson(dataJson);
          rtnEtfStocks.add(dataStock);
          rtnEtfStocks.add(EtfStockInfo.fromInitJson());
        } else if (dataLength == 0) {
          print("44####################################");
          rtnEtfStocks.add(EtfStockInfo.fromInitJson());
          rtnEtfStocks.add(EtfStockInfo.fromInitJson());
        } else {
          print("55####################################");
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
              width: 238,
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
            child: Card(
                elevation: 5,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 3, top: 5, right: 10),
                      child: Table(
                        // columnWidths: ,
                        border: TableBorder(
                          bottom: BorderSide(
                            color: Colors.blueGrey,
                            style: BorderStyle.none,
                            width: 1.0,
                          ),
                          horizontalInside: BorderSide(
                            color: Colors.white,
                            style: BorderStyle.none,
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
                                    getUpDownIcon(_marketInfo.exRauTotScore),
                                    size: 24,
                                    color: getColor(_marketInfo.exRauTotScore),
                                  ),
                                  Text(
                                      '${_marketInfo.exRauTotScore}[${_marketInfo.exRauTotScoreGrade}] ',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: getColor(
                                              _marketInfo.exRauTotScore))),
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    getUpDownIcon(_marketInfo.excScore1st),
                                    size: 24,
                                    color: getColor(_marketInfo.excScore1st),
                                  ),
                                  Text(
                                      //' $_excScore1st [$_excSetRngGrp]',
                                      '${_marketInfo.excScore1st}[${_marketInfo.excSetRngGrp}] ',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: getColor(
                                              _marketInfo.excScore1st))),
                                ]),
                          ]),
                        ],
                      ),
                    )))),
        SizedBox(height: 10),
        SizedBox(height: 10),
        Card(
          elevation: 5,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.only(left: 3, top: 5),
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
                    0: FractionColumnWidth(.22),
                    1: FractionColumnWidth(.28),
                    2: FractionColumnWidth(.30),
                    3: FractionColumnWidth(.20)
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
                        getSelectStock(_marketInfo.selectStock,
                            _marketInfo.otType, 1),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              getUpDownIcon(_marketInfo.buyRate1st),
                              size: 25,
                              color:
                              getColor(_marketInfo.buyRate1st),
                            ),
                            Text(getBuyRate(_marketInfo.buyRate1st),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: getColor(
                                        _marketInfo.buyRate1st))),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              getUpDownIcon(_marketInfo.minusDecide1st),
                              size: 25,
                              color: getColor(
                                  _marketInfo.minusDecide1st),
                            ),
                            Text('${_marketInfo.minusDecide1st}% ',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: getColor(_marketInfo.minusDecide1st))),
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
                        getSelectStock(_marketInfo.selectStock,
                            _marketInfo.otType, 2),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              getUpDownIcon(_marketInfo.buyRate2nd),
                              size: 25,
                              color:
                              getColor(_marketInfo.buyRate2nd),
                            ),
                            Text('${_marketInfo.buyRate2nd}% ',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: getColor(
                                        _marketInfo.buyRate2nd))),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              getUpDownIcon(_marketInfo.minusDecide2nd),
                              size: 25,
                              color: getColor(
                                  _marketInfo.minusDecide2nd),
                            ),
                            Text('${_marketInfo.minusDecide2nd}% ',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: getColor(_marketInfo.minusDecide2nd))),
                          ]),
                    ]),
                  ],
                ),)),
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
        SizedBox(height: 20),
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
                                if (_selectedEtf == 'undefined' ||
                                    _selectedEtf == null ||
                                    _selectedEtf == 0.0) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('[Info]'),
                                          content: Text('ETF 종목을 선택해주세요!'),
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
                                } else {
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
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.movie,
                                    size: 25,
                                  ),
                                  Text(
                                    "ETF 정보 조회",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                            )
                          ]),
                      SizedBox(height: 10),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("당일 마감정보는 3시 40분 이후에 확인이 가능합니다.",
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                letterSpacing: 2.0,
                              ))),
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
                                Text('    1순위 정보    ',
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 3.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: getImage(
                                                                snapshot.data[0]
                                                                    .etfStockType),
                                                          ),
                                                        ),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    '\n ${snapshot.data[0].etfStockName} ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .pinkAccent),
                                                                  ),
                                                                ],
                                                              ),
                                                              Table(
                                                                // columnWidths: ,
                                                                border:
                                                                    TableBorder(
                                                                  bottom:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .blueGrey,
                                                                    style: BorderStyle
                                                                        .solid,
                                                                    width: 1.0,
                                                                  ),
                                                                  horizontalInside:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    style: BorderStyle
                                                                        .solid,
                                                                    width: 1.0,
                                                                  ),
                                                                  left:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                  right:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                  top:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                  verticalInside:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                ),
                                                                //defaultColumnWidth: FixedColumnWidth(60.0),
                                                                columnWidths: {
                                                                  0: FixedColumnWidth(
                                                                      50.0),
                                                                  1: FixedColumnWidth(
                                                                      95.0),
                                                                  2: FixedColumnWidth(
                                                                      50.0),
                                                                  3: FixedColumnWidth(
                                                                      100.0),
                                                                },

                                                                children: [
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            '기준가:',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11,
                                                                                color: Colors.green)),
                                                                        Text(getNumberWithComma(snapshot.data[0].etfBefClosePrice),
                                                                            textAlign: TextAlign
                                                                                .end,
                                                                            style: TextStyle(
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                        Text(
                                                                            ' ',
                                                                            style:
                                                                                TextStyle(fontSize: 10, color: Colors.green)),
                                                                        Text(
                                                                            ' ',
                                                                            style:
                                                                                TextStyle(fontSize: 10, color: Colors.black)),
                                                                      ]),
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            '시가(%):\n ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11,
                                                                                color: Colors.green)),
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                getNumberWithComma(snapshot.data[0].etfOpenPrice),
                                                                                textAlign: TextAlign.end,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Icon(
                                                                                    getUpDownIcon(snapshot.data[0].etfUdRateRealByOpen),
                                                                                    size: 13,
                                                                                    color: getColor(snapshot.data[0].etfUdRateRealByOpen),
                                                                                  ),
                                                                                  Text(
                                                                                    '${snapshot.data[0].etfUdRateRealByOpen}%[' + getNumberWithComma(snapshot.data[0].etfOpenPrice - snapshot.data[0].etfBefClosePrice) + '] ',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: getColor(snapshot.data[0].etfUdRateRealByOpen)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ]),
                                                                        Text(
                                                                            '  종가(%):\n ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11,
                                                                                color: Colors.green)),
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                getNumberWithComma(snapshot.data[0].etfClosePrice),
                                                                                textAlign: TextAlign.end,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Icon(
                                                                                    getUpDownIcon(snapshot.data[0].etfUdRateRealByClose),
                                                                                    size: 13,
                                                                                    color: getColor(snapshot.data[0].etfUdRateRealByClose),
                                                                                  ),
                                                                                  Text(
                                                                                    '${snapshot.data[0].etfUdRateRealByClose}%[' + getNumberWithComma(snapshot.data[0].etfClosePrice - snapshot.data[0].etfBefClosePrice) + '] ',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: getColor(snapshot.data[0].etfUdRateRealByClose)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ]),
                                                                      ]),
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            '고가(%):\n ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11,
                                                                                color: Colors.green)),
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                getNumberWithComma(snapshot.data[0].etfHighPrice),
                                                                                textAlign: TextAlign.end,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Icon(
                                                                                    getUpDownIcon(snapshot.data[0].etfUdRateRealByHigh),
                                                                                    size: 13,
                                                                                    color: getColor(snapshot.data[0].etfUdRateRealByHigh),
                                                                                  ),
                                                                                  Text(
                                                                                    '${snapshot.data[0].etfUdRateRealByHigh}%[' + getNumberWithComma(snapshot.data[0].etfHighPrice - snapshot.data[0].etfBefClosePrice) + '] ',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: getColor(snapshot.data[0].etfUdRateRealByHigh)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ]),
                                                                        Text(
                                                                            '  저가(%):\n ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11,
                                                                                color: Colors.green)),
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                getNumberWithComma(snapshot.data[0].etfLowPrice),
                                                                                textAlign: TextAlign.end,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Icon(
                                                                                    getUpDownIcon(snapshot.data[0].etfUdRateRealByLow),
                                                                                    size: 13,
                                                                                    color: getColor(snapshot.data[0].etfUdRateRealByLow),
                                                                                  ),
                                                                                  Text(
                                                                                    '${snapshot.data[0].etfUdRateRealByLow}%[' + getNumberWithComma(snapshot.data[0].etfLowPrice - snapshot.data[0].etfBefClosePrice) + '] ',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: getColor(snapshot.data[0].etfUdRateRealByLow)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ]),
                                                                      ]),
                                                                ],
                                                              ),
                                                            ]),
                                                      ]),
                                                  SizedBox(height: 10),
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
                                                      0: FixedColumnWidth(75.0),
                                                      1: FixedColumnWidth(150.0),
                                                      2: FixedColumnWidth(
                                                          150.0),
                                                    },

                                                    children: [
                                                      TableRow(children: [
                                                        Text('  예약가(%): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .teal)),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text('  ',
                                                                textAlign:
                                                                TextAlign
                                                                    .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    13,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: Colors
                                                                        .black)),
                                                            Icon(
                                                              getUpDownIcon(snapshot
                                                                  .data[0]
                                                                  .etfRsvBuyRate),
                                                              size: 16,
                                                              color: getColor(
                                                                  snapshot
                                                                      .data[0]
                                                                      .etfRsvBuyRate),
                                                            ),
                                                            Text(
                                                              getBuyRate(snapshot.data[0].etfRsvBuyRate),
                                                              textAlign:
                                                              TextAlign.end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 14,
                                                                  color: getColor(
                                                                      snapshot.data[0].etfRsvBuyRate)),
                                                            ),
                                                          ],
                                                        ),
                                                        Text('  ',
                                                            textAlign:
                                                            TextAlign
                                                                .end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                      TableRow(children: [
                                                        Text('  예약가(원): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .teal)),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text('  ',
                                                                textAlign:
                                                                TextAlign
                                                                    .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    13,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: Colors
                                                                        .black)),
                                                            Text(
                                                              getNumberWithComma(
                                                                  snapshot.data[0]
                                                                      .etfRsvBuyPrc),
                                                              textAlign:
                                                              TextAlign.end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 13,
                                                                  color:
                                                                  Colors.black),
                                                            ),
                                                            Icon(
                                                              getUpDownIcon(snapshot
                                                                  .data[0]
                                                                  .etfRsvBuyRate),
                                                              size: 16,
                                                              color: getColor(
                                                                  snapshot
                                                                      .data[0]
                                                                      .etfRsvBuyRate),
                                                            ),
                                                            Text(
                                                              '[' + getNumberWithComma(
                                                                          snapshot.data[0].etfRsvBuyPrc 
                                                                      - snapshot.data[0].etfOpenPrice) + '] ',
                                                              textAlign:
                                                              TextAlign.end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 14,
                                                                  color: getColor(
                                                                      snapshot.data[0].etfRsvBuyRate)),
                                                            ),
                                                          ],
                                                        ),
                                                        Text('  ',
                                                            textAlign:
                                                            TextAlign
                                                                .end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                      TableRow(children: [
                                                        Text('  손절(%): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .teal)),
                                                        Text(
                                                            '${_marketInfo.minusDecide1st}% ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black)),
                                                        Text('  ',
                                                            textAlign:
                                                            TextAlign
                                                                .end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                      TableRow(children: [
                                                        Text('  체결여부: ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .teal)),
                                                        Text(
                                                            getYn(snapshot
                                                                .data[0]
                                                                .etfTodayConclYn),
                                                            textAlign:
                                                            TextAlign
                                                                .end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                        Text(' ',
                                                            textAlign:
                                                            TextAlign
                                                                .start,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .teal)),
                                                      ]),
                                                    ],
                                                  ),
                                                ]))))),
                            SizedBox(height: 20),
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
                                      Text('    2순위 정보    ',
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 3.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: getImage(
                                                                snapshot.data[1]
                                                                    .etfStockType),
                                                          ),
                                                        ),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    '\n ${snapshot.data[1].etfStockName} ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .pinkAccent),
                                                                  ),
                                                                ],
                                                              ),
                                                              Table(
                                                                // columnWidths: ,
                                                                border:
                                                                    TableBorder(
                                                                  bottom:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .blueGrey,
                                                                    style: BorderStyle
                                                                        .solid,
                                                                    width: 1.0,
                                                                  ),
                                                                  horizontalInside:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    style: BorderStyle
                                                                        .solid,
                                                                    width: 1.0,
                                                                  ),
                                                                  left:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                  right:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                  top:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                  verticalInside:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                ),
                                                                //defaultColumnWidth: FixedColumnWidth(60.0),
                                                                columnWidths: {
                                                                  0: FixedColumnWidth(
                                                                      50.0),
                                                                  1: FixedColumnWidth(
                                                                      95.0),
                                                                  2: FixedColumnWidth(
                                                                      50.0),
                                                                  3: FixedColumnWidth(
                                                                      100.0),
                                                                },

                                                                children: [
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            '기준가:',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11,
                                                                                color: Colors.green)),
                                                                        Text(getNumberWithComma(snapshot.data[1].etfBefClosePrice),
                                                                            textAlign: TextAlign
                                                                                .end,
                                                                            style: TextStyle(
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                        Text(
                                                                            ' ',
                                                                            style:
                                                                                TextStyle(fontSize: 10, color: Colors.green)),
                                                                        Text(
                                                                            ' ',
                                                                            style:
                                                                                TextStyle(fontSize: 10, color: Colors.black)),
                                                                      ]),
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            '시가(%):\n ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11,
                                                                                color: Colors.green)),
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                getNumberWithComma(snapshot.data[1].etfOpenPrice),
                                                                                textAlign: TextAlign.end,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Icon(
                                                                                    getUpDownIcon(snapshot.data[1].etfUdRateRealByOpen),
                                                                                    size: 13,
                                                                                    color: getColor(snapshot.data[1].etfUdRateRealByOpen),
                                                                                  ),
                                                                                  Text(
                                                                                    '${snapshot.data[1].etfUdRateRealByOpen}%[' + getNumberWithComma(snapshot.data[1].etfOpenPrice - snapshot.data[1].etfBefClosePrice) + '] ',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: getColor(snapshot.data[1].etfUdRateRealByOpen)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ]),
                                                                        Text(
                                                                            '  종가(%):\n ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11,
                                                                                color: Colors.green)),
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                getNumberWithComma(snapshot.data[1].etfClosePrice),
                                                                                textAlign: TextAlign.end,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Icon(
                                                                                    getUpDownIcon(snapshot.data[1].etfUdRateRealByClose),
                                                                                    size: 13,
                                                                                    color: getColor(snapshot.data[1].etfUdRateRealByClose),
                                                                                  ),
                                                                                  Text(
                                                                                    '${snapshot.data[1].etfUdRateRealByClose}%[' + getNumberWithComma(snapshot.data[1].etfClosePrice - snapshot.data[1].etfBefClosePrice) + '] ',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: getColor(snapshot.data[1].etfUdRateRealByClose)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ]),
                                                                      ]),
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            '고가(%):\n ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11,
                                                                                color: Colors.green)),
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                getNumberWithComma(snapshot.data[1].etfHighPrice),
                                                                                textAlign: TextAlign.end,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Icon(
                                                                                    getUpDownIcon(snapshot.data[1].etfUdRateRealByHigh),
                                                                                    size: 13,
                                                                                    color: getColor(snapshot.data[1].etfUdRateRealByHigh),
                                                                                  ),
                                                                                  Text(
                                                                                    '${snapshot.data[1].etfUdRateRealByHigh}%[' + getNumberWithComma(snapshot.data[1].etfHighPrice - snapshot.data[1].etfBefClosePrice) + '] ',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: getColor(snapshot.data[1].etfUdRateRealByHigh)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ]),
                                                                        Text(
                                                                            '  저가(%):\n ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 11,
                                                                                color: Colors.green)),
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                getNumberWithComma(snapshot.data[1].etfLowPrice),
                                                                                textAlign: TextAlign.end,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  Icon(
                                                                                    getUpDownIcon(snapshot.data[1].etfUdRateRealByLow),
                                                                                    size: 13,
                                                                                    color: getColor(snapshot.data[1].etfUdRateRealByLow),
                                                                                  ),
                                                                                  Text(
                                                                                    '${snapshot.data[1].etfUdRateRealByLow}%[' + getNumberWithComma(snapshot.data[1].etfLowPrice - snapshot.data[1].etfBefClosePrice) + '] ',
                                                                                    textAlign: TextAlign.end,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: getColor(snapshot.data[1].etfUdRateRealByLow)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ]),
                                                                      ]),
                                                                ],
                                                              ),
                                                            ]),
                                                      ]),
                                                  SizedBox(height: 10),
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
                                                      0: FixedColumnWidth(75.0),
                                                      1: FixedColumnWidth(150.0),
                                                      2: FixedColumnWidth(
                                                          150.0),
                                                    },

                                                    children: [
                                                      TableRow(children: [
                                                        Text('  예약가(%): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .teal)),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text('  ',
                                                                textAlign:
                                                                TextAlign
                                                                    .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    13,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: Colors
                                                                        .black)),
                                                            Icon(
                                                              getUpDownIcon(snapshot
                                                                  .data[0]
                                                                  .etfRsvBuyRate),
                                                              size: 16,
                                                              color: getColor(
                                                                  snapshot
                                                                      .data[1]
                                                                      .etfRsvBuyRate),
                                                            ),
                                                            Text(
                                                              '${snapshot.data[1].etfRsvBuyRate}%',
                                                              textAlign:
                                                              TextAlign.end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 14,
                                                                  color: getColor(
                                                                      snapshot.data[1].etfRsvBuyRate)),
                                                            ),
                                                          ],
                                                        ),
                                                        Text('  ',
                                                            textAlign:
                                                            TextAlign
                                                                .end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                      TableRow(children: [
                                                        Text('  예약가(원): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .teal)),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text('  ',
                                                                textAlign:
                                                                TextAlign
                                                                    .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    13,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    color: Colors
                                                                        .black)),
                                                            Text(
                                                              getNumberWithComma(
                                                                  snapshot.data[1]
                                                                      .etfRsvBuyPrc),
                                                              textAlign:
                                                              TextAlign.end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 13,
                                                                  color:
                                                                  Colors.black),
                                                            ),
                                                            Icon(
                                                              getUpDownIcon(snapshot
                                                                  .data[1]
                                                                  .etfRsvBuyRate),
                                                              size: 16,
                                                              color: getColor(
                                                                  snapshot
                                                                      .data[1]
                                                                      .etfRsvBuyRate),
                                                            ),
                                                            Text(
                                                              '[' + getNumberWithComma(
                                                                  snapshot.data[1].etfRsvBuyPrc
                                                                      - snapshot.data[1].etfOpenPrice) + '] ',
                                                              textAlign:
                                                              TextAlign.end,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 14,
                                                                  color: getColor(
                                                                      snapshot.data[1].etfRsvBuyRate)),
                                                            ),
                                                          ],
                                                        ),
                                                        Text('  ',
                                                            textAlign:
                                                            TextAlign
                                                                .end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                      TableRow(children: [
                                                        Text('  손절(%): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .teal)),
                                                        Text(
                                                            '${_marketInfo.minusDecide2nd}% ',
                                                            textAlign:
                                                            TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                        Text('  ',
                                                            textAlign:
                                                            TextAlign
                                                                .end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                      TableRow(children: [
                                                        Text('  체결여부: ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .teal)),
                                                        Text(
                                                            getYn(snapshot
                                                                .data[1]
                                                                .etfTodayConclYn),
                                                            textAlign:
                                                            TextAlign
                                                                .end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                        Text(' ',
                                                            textAlign:
                                                            TextAlign
                                                                .start,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .teal)),
                                                      ]),
                                                    ],
                                                  ),
                                                ]))))),
                            SizedBox(height: 20),
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
                                      Text('    투자 Result 정보    ',
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
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      '기준 투자금액:' ,
                                      textAlign:
                                      TextAlign
                                          .end,
                                      style: TextStyle(
                                          fontSize:
                                          16,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          color: Colors.blueGrey)),
                                  DropdownButton<StdPrcTyItem>(
                                    hint: Text("기준 투자금액을 선택해주세요."),
                                    value: selectedStdPrcTy,
                                    onChanged: (StdPrcTyItem Value) {
                                      setState(() {
                                        selectedStdPrcTy = Value;
                                        _selectedStdPrcTy = Value.id;
                                        _selectedStdPrcTyNm =  Value.name;
                                      });
                                    },
                                    items: stdPrcTy.map((StdPrcTyItem user) {
                                      return DropdownMenuItem<StdPrcTyItem>(
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
                                ]),
                            SizedBox(height: 10),
                            Container(
                                padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                height: 270,
                                width: 440,
                                child: Card(
                                    elevation: 5,
                                    child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3, top: 5),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 3.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Image.asset('images/logo_result_blue.png', height: 100, width: 110),
                                                          ),
                                                        ),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              Table(
                                                                // columnWidths: ,
                                                                border:
                                                                    TableBorder(
                                                                  bottom:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .blueGrey,
                                                                    style: BorderStyle
                                                                        .solid,
                                                                    width: 1.0,
                                                                  ),
                                                                  horizontalInside:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    style: BorderStyle
                                                                        .solid,
                                                                    width: 1.0,
                                                                  ),
                                                                  left:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                  right:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                  top:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                  verticalInside:
                                                                      BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                  ),
                                                                ),
                                                                //defaultColumnWidth: FixedColumnWidth(60.0),
                                                                columnWidths: {
                                                                  0: FixedColumnWidth(
                                                                      90.0),
                                                                  1: FixedColumnWidth(
                                                                      160.0)
                                                                },

                                                                children: [

                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            '당일체결종목:',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 12,
                                                                                color: Colors.green)),
                                                                        Text(
                                                                                getSelectResultStock(
                                                                                snapshot.data[0].etfTodayConclYn, snapshot.data[1].etfTodayConclYn,
                                                                                snapshot.data[0].etfStockName, snapshot.data[1].etfStockName
                                                                            ),
                                                                            textAlign: TextAlign
                                                                                .end,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.pinkAccent)),
                                                                      ]),
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            '당일체결여부:',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 12,
                                                                                color: Colors.green)),
                                                                        Text(''+getConclYn(snapshot.data[0].etfTodayConclYn, snapshot.data[1].etfTodayConclYn),
                                                                            textAlign: TextAlign
                                                                                .end,
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                      ]),
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            ' ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 12,
                                                                                color: Colors.green)),
                                                                        Text( ' ',
                                                                            textAlign: TextAlign
                                                                                .end,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.pinkAccent)),
                                                                      ]),
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            ' ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 12,
                                                                                color: Colors.green)),
                                                                        Text( ' ',
                                                                            textAlign: TextAlign
                                                                                .end,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.pinkAccent)),
                                                                      ]),
                                                                  TableRow(
                                                                      children: [
                                                                        Text(
                                                                            ' ',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 12,
                                                                                color: Colors.green)),
                                                                        Text( ' ',
                                                                            textAlign: TextAlign
                                                                                .end,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.pinkAccent)),
                                                                      ]),
                                                                ],
                                                              ),
                                                            ]),
                                                      ]),
                                                  SizedBox(height: 10),
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
                                                      0: FixedColumnWidth(120.0),
                                                      1: FixedColumnWidth(135.0),
                                                      2: FixedColumnWidth(
                                                          105.0),
                                                    },

                                                    children: [
                                                      TableRow(children: [
                                                        Text(' 일수익(%): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .teal)),
                                                        Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Icon(
                                                                getUpDownIcon(
                                                                    snapshot.data[0].etfTodayResultRate),
                                                                size: 16,
                                                                color: getColor(
                                                                    snapshot.data[0].etfTodayResultRate),
                                                              ),
                                                              Text(
                                                                  '${snapshot.data[0].etfTodayResultRate}% ',
                                                                  textAlign:
                                                                  TextAlign
                                                                      .end,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                      color: getColor(snapshot.data[0].etfTodayResultRate))),
                                                            ]),
                                                        Text('  ',
                                                            textAlign:
                                                            TextAlign
                                                                .end,
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                      TableRow(children: [
                                                        Text(' 일수익(원): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .teal)),
                                                        Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Icon(
                                                                getUpDownIcon(
                                                                    snapshot.data[0].etfTodayResultRate),
                                                                size: 16,
                                                                color: getColor(
                                                                    snapshot.data[0].etfTodayResultRate),
                                                              ),
                                                              Text(
                                                                  getStdPrcTp(
                                                                      _selectedStdPrcTy,
                                                                      snapshot.data[0]
                                                                          .etfTodayResultRevenue,
                                                                      snapshot.data[0]
                                                                          .etfTodayResultRevenueV3,
                                                                      snapshot.data[0]
                                                                          .etfTodayResultRevenueV5
                                                                  ),
                                                                  textAlign:
                                                                  TextAlign
                                                                      .end,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                      color: getColor(snapshot.data[0].etfTodayResultRate))),
                                                            ]),
                                                        Text('  [기준 '+getStdPrcNm(_selectedStdPrcTyNm)+']',
                                                            textAlign:
                                                            TextAlign
                                                                .start,
                                                            style: TextStyle(
                                                                fontSize:
                                                                12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                      TableRow(children: [
                                                        Text(' 월수익(%): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .teal)),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Icon(
                                                                getUpDownIcon(
                                                                    snapshot.data[0].etfMonthAggregateRate),
                                                                size: 16,
                                                                color: getColor(
                                                                    snapshot.data[0].etfMonthAggregateRate),
                                                              ),
                                                              Text(
                                                                  '${snapshot.data[0].etfMonthAggregateRate}% ',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: getColor(snapshot.data[0].etfMonthAggregateRate))),
                                                            ]),
                                                        Text(
                                                            '  ',
                                                            textAlign:
                                                            TextAlign
                                                                .start,
                                                            style: TextStyle(
                                                                fontSize:
                                                                11,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .deepOrange)),
                                                      ]),
                                                      TableRow(children: [
                                                        Text(' 단리형 월수익(원): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .teal)),
                                                        Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Icon(
                                                                getUpDownIcon(
                                                                    snapshot.data[0].etfMonthAggregateRate),
                                                                size: 16,
                                                                color: getColor(
                                                                    snapshot.data[0].etfMonthAggregateRate),
                                                              ),
                                                              Text(
                                                                  getStdPrcTp(
                                                                      _selectedStdPrcTy,
                                                                      snapshot.data[0]
                                                                          .etfMonthSimpleAggrPrice,
                                                                      snapshot.data[0]
                                                                          .etfMonthSimpleAggrPriceV3,
                                                                      snapshot.data[0]
                                                                          .etfMonthSimpleAggrPriceV5
                                                                  ),
                                                                  textAlign:
                                                                  TextAlign
                                                                      .end,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                      color: getColor(snapshot.data[0].etfMonthAggregateRate))),
                                                            ]),
                                                        Text('  [기준 '+getStdPrcNm(_selectedStdPrcTyNm)+']',
                                                            textAlign:
                                                            TextAlign
                                                                .start,
                                                            style: TextStyle(
                                                                fontSize:
                                                                12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                      TableRow(children: [
                                                        Text(' 복리형 월수익(원): ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .teal)),
                                                        Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Icon(
                                                                getUpDownIcon(
                                                                    snapshot.data[0].etfMonthAggregateRate),
                                                                size: 16,
                                                                color: getColor(
                                                                    snapshot.data[0].etfMonthAggregateRate),
                                                              ),
                                                              Text(
                                                                  getStdPrcTp(
                                                                      _selectedStdPrcTy,
                                                                      snapshot.data[0]
                                                                          .etfMonthAggregatePrice,
                                                                      snapshot.data[0]
                                                                          .etfMonthAggregatePriceV3,
                                                                      snapshot.data[0]
                                                                          .etfMonthAggregatePriceV5
                                                                  ),
                                                                  textAlign:
                                                                  TextAlign
                                                                      .end,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                      color: getColor(snapshot.data[0].etfMonthAggregateRate))),
                                                            ]),
                                                        Text('  [기준 '+getStdPrcNm(_selectedStdPrcTyNm)+']',
                                                            textAlign:
                                                            TextAlign
                                                                .start,
                                                            style: TextStyle(
                                                                fontSize:
                                                                12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ]),
                                                    ],
                                                  ),
                                                ]))))),
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

class StdPrcTyItem {
  const StdPrcTyItem(this.id, this.name, this.icon);

  final String name;
  final String id;
  final Icon icon;
}
