import 'package:flutter/material.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import "package:flutter_dibr_do_kospi/ad_manager.dart";
import "package:flutter_dibr_do_kospi/main.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MyResultPage extends StatelessWidget {
  final double snpValue;

  final double euroValue;

  final double wtiValue;

  final double dubValue;

  final double breValue;

  MyResultPage(this.snpValue, this.euroValue, this.wtiValue, this.dubValue,
      this.breValue);

  @override
  Widget build(BuildContext context) {
    final double _totScore =
        ((snpValue + euroValue + (wtiValue + dubValue + breValue) / 3) * 100)
            .roundToDouble() /
            100;

    int _totGrade = 0;

    int _exRGrade = 0;

    double invRate1st = 0.0;

    double invRate2nd = 0.0;

    var invStock1st = '';

    var invStock2nd = '';

    double invMinRate1st = 0.0;

    double invMinRate2nd = 0.0;

    double invMaxRate1st = 0.0;

    double invMaxRate2nd = 0.0;

    return Scaffold(
      appBar: AppBar(title: Text('DIBR 투자 추천')),
      body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
        SizedBox(height: 10),
        Align(
            alignment: Alignment.bottomCenter,
            child: Text("[DIBR]투자 점수",
                style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    letterSpacing: 4.0))),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  left: BorderSide(width: 1.0, color: Colors.black),
                  right: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('S&P:',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red))
                      ])),
            ),
          ),
          Text('  RATE[$snpRate]%, SCORE[$snpScore]점',
              textAlign: TextAlign.start,
              style: TextStyle(color: Color(0xFF000000)))
        ]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  left: BorderSide(width: 1.0, color: Colors.black),
                  right: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('유로:',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.amber))
                      ])),
            ),
          ),
          Text('  RATE[$euroRate]%, SCORE[$euroScore]점',
              textAlign: TextAlign.start,
              style: TextStyle(color: Color(0xFF000000)))
        ]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  left: BorderSide(width: 1.0, color: Colors.black),
                  right: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('OIL:',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.purple))
                      ])),
            ),
          ),
          Text(
              '  WTI[$wtiRate]%, DUBAI[$dubRate]%, BRENT[$breRate]% \n  SCORE[$oilScore]점',
              textAlign: TextAlign.start,
              style: TextStyle(color: Color(0xFF000000)))
        ]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  left: BorderSide(width: 1.0, color: Colors.black),
                  right: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('환율:',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.lightBlue))
                      ])),
            ),
          ),
          Text('  마감환[$exRtBfRate]원, 시작환[$exRtCrRate]원\n  환율[$exRtRate]',
              textAlign: TextAlign.start,
              style: TextStyle(color: Color(0xFF000000)))
        ]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  left: BorderSide(width: 1.0, color: Colors.black),
                  right: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('TOT:',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.green))
                      ])),
            ),
          ),
          Text(
              '  환율제외[$_totScore]점 등급[$_totGrade]점\n  환율[$exRtScore]점 등급[$_exRGrade]점',
              textAlign: TextAlign.start,
              style: TextStyle(color: Color(0xFF000000)))
        ]),
        SizedBox(height: 20),
        Align(
            alignment: Alignment.bottomCenter,
            child: Text("[DIBR]오늘의 투자",
                style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    letterSpacing: 4.0))),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  left: BorderSide(width: 1.0, color: Colors.black),
                  right: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('시작가:',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.blueGrey))
                      ])),
            ),
          ),
          Text('  레버리지[$strtLvrsPrice]원\n  인버스[$strtInvsPrice]점',
              textAlign: TextAlign.start,
              style: TextStyle(color: Color(0xFF000000)))
        ]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  left: BorderSide(width: 1.0, color: Colors.black),
                  right: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('1순위:',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red))
                      ])),
            ),
          ),
          Text(
              '  선택종목[$invStock1st] 매수가격[$buyPrice1st]원(-$invRate1st%)\n  손절가격[$sellDownPrice1st]원 실현가격[$sellUpPrice1st]점',
              textAlign: TextAlign.start,
              style: TextStyle(color: Color(0xFF000000)))
        ]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  left: BorderSide(width: 1.0, color: Colors.black),
                  right: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('2순위:',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.blue))
                      ])),
            ),
          ),
          Text(
              '  선택종목[$invStock2nd] 매수가격[$buyPrice2nd]원(-$invRate2nd%)\n  손절가격[$sellDownPrice2nd]원 실현가격[$sellUpPrice2nd]점',
              textAlign: TextAlign.start,
              style: TextStyle(color: Color(0xFF000000)))
        ]),
        SizedBox(height: 50),
        RaisedButton(
            child: Text('돌아가기', style: TextStyle(color: Colors.white)),
            color: Colors.teal,
            onPressed: () {
              print('RaiseButton 실행!');

              CircularProgressIndicator();

              Navigator.of(context).pop();
            })
      ]),
    );
  }
}