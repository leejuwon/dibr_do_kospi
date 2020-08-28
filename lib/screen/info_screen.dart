import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import "package:flutter_dibr_do_kospi/ad_manager.dart";
import "package:flutter_dibr_do_kospi/screen/result_screen.dart";
import "package:flutter_dibr_do_kospi/main.dart";
import "package:flutter_dibr_do_kospi/model/model_market.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DibrInfoPage extends StatefulWidget {
  @override
  _DibrInfoPageState createState() => _DibrInfoPageState();
}

class _DibrInfoPageState extends State<DibrInfoPage> {
  final tabId = 'dibrInfo';

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    return ListView(scrollDirection: Axis.vertical, children: <Widget>[
      SizedBox(height: 10),
      SingleChildScrollView(
          child: ListBody(children: <Widget>[
        SizedBox(height: 10),
        ExpandableListViewSingle(
            title: "S&P500 Rate", sInfo: "snp", stdRate: 0.43),
        ExpandableListViewSingle(
            title: "EUROPE STOXX50 Rate", sInfo: "euro", stdRate: 0.77),
        ExpandableListViewSingle(
            title: "WTI OIL Rate", sInfo: "wti", stdRate: 2.06),
        ExpandableListViewSingle(
            title: "DUBAI OIL Rate", sInfo: "dub", stdRate: 1.61),
        ExpandableListViewSingle(
            title: "BRENT OIL Rate", sInfo: "bre", stdRate: 1.79),
        ExpandableListViewSingle(
            title: "기준 USD/KRW", sInfo: "ber", stdRate: 0.08),
        ExpandableListViewSingle(
            title: "시작 USD/KRW", sInfo: "cer", stdRate: 0.08),
        ExpandableListViewSingle(title: "인버스 시가", sInfo: "ivs", stdRate: 0.0),
        ExpandableListViewSingle(title: "레버리지 시가", sInfo: "lvg", stdRate: 0.0),
        SizedBox(height: 20),
        Align(
            alignment: Alignment.bottomCenter,
            child: Text("(주)Ju&Ju Partner",
                style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                    letterSpacing: 4.0)))
      ]))
    ]);
  }
}
