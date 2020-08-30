//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EtfStockInfo {
  final String etfStockDate;
  final String etfBfStockDate;
  final String etfStockId;
  final String etfStockName;
  final double etfBefClosePrice;
  final double etfOpenPrice;
  final double etfHighPrice;
  final double etfLowPrice ;
  final double etfClosePrice ;
  final double etfTodayDiffPrice ;
  final double etfUdRateRealByToday;
  final double etfUdRateRealByOpen ;
  final double etfUdRateRealByClose;
  final double etfUdRateRealByLow;
  final double etfUdRateRealByHigh ;
  final String beforeEtfOpenDoYn;
  final String afterEtfOpenDoYn;
  final String closeEtfOpenDoYn;
  final double etfMonthAggregateRate;
  final double etfMonthAggregatePrice;
  final double etfYearAggregateRate;
  final double etfYearAggregatePrice;
  final String etfTodayConclYn;
  final double etfTodayResultRate;
  final double etfRsvBuyRate;
  final double etfRsvBuyPrc;
  final String etfStockGroup;
  final String etfStockType;


  //final DocumentReference reference;

  EtfStockInfo({
    this.etfStockDate,
    this.etfBfStockDate,
    this.etfStockId,
    this.etfStockName,
    this.etfBefClosePrice,
    this.etfOpenPrice,
    this.etfHighPrice,
    this.etfLowPrice ,
    this.etfClosePrice ,
    this.etfTodayDiffPrice ,
    this.etfUdRateRealByToday,
    this.etfUdRateRealByOpen ,
    this.etfUdRateRealByClose,
    this.etfUdRateRealByLow,
    this.etfUdRateRealByHigh ,
    this.beforeEtfOpenDoYn,
    this.afterEtfOpenDoYn,
    this.closeEtfOpenDoYn,
    this.etfMonthAggregateRate,
    this.etfMonthAggregatePrice,
    this.etfYearAggregateRate,
    this.etfYearAggregatePrice,
    this.etfTodayConclYn,
    this.etfTodayResultRate,
    this.etfRsvBuyRate,
    this.etfRsvBuyPrc,
    this.etfStockGroup,
    this.etfStockType
  });

  factory EtfStockInfo.fromJson(Map<String, dynamic> map){
        //, {this.reference})
      return EtfStockInfo(
        etfStockDate: map['etfStockDate'],
        etfBfStockDate: map['etfBfStockDate'],
        etfStockId: map['etfStockId'],
        etfStockName: map['etfStockName'],
        etfBefClosePrice: map['etfBefClosePrice'] == null? 0.0 : map['etfBefClosePrice'].toDouble(),
        etfOpenPrice: map['etfOpenPrice'] == null? 0.0 : map['etfOpenPrice'].toDouble(),
        etfHighPrice: map['etfHighPrice'] == null? 0.0 : map['etfHighPrice'].toDouble(),
        etfLowPrice : map['etfLowPrice'] == null? 0.0 : map['etfLowPrice'].toDouble(),
        etfClosePrice : map['etfClosePrice'] == null? 0.0 : map['etfClosePrice'].toDouble(),
        etfTodayDiffPrice : map['etfTodayDiffPrice'] == null? 0.0 : map['etfTodayDiffPrice'].toDouble(),
        etfUdRateRealByToday: map['etfUdRateRealByToday'] == null? 0.0 : map['etfUdRateRealByToday'].toDouble(),
        etfUdRateRealByOpen : map['etfUdRateRealByOpen'] == null? 0.0 : map['etfUdRateRealByOpen'].toDouble(),
        etfUdRateRealByClose: map['etfUdRateRealByClose'] == null? 0.0 : map['etfUdRateRealByClose'].toDouble(),
        etfUdRateRealByLow: map['etfUdRateRealByLow'] == null? 0.0 : map['etfUdRateRealByLow'].toDouble(),
        etfUdRateRealByHigh : map['etfUdRateRealByHigh'] == null? 0.0 : map['etfUdRateRealByHigh'].toDouble(),
        beforeEtfOpenDoYn: map['beforeEtfOpenDoYn'],
        afterEtfOpenDoYn: map['afterEtfOpenDoYn'],
        closeEtfOpenDoYn: map['closeEtfOpenDoYn'],
        etfMonthAggregateRate: map['etfMonthAggregateRate'] == null? 0.0 : map['etfMonthAggregateRate'].toDouble(),
        etfMonthAggregatePrice: map['etfMonthAggregatePrice'] == null? 0.0 : map['etfMonthAggregatePrice'].toDouble(),
        etfYearAggregateRate: map['etfYearAggregateRate'] == null? 0.0 : map['etfYearAggregateRate'].toDouble(),
        etfYearAggregatePrice: map['etfYearAggregatePrice'] == null? 0.0 : map['etfYearAggregatePrice'].toDouble(),
        etfTodayConclYn: map['etfTodayConclYn'],
        etfTodayResultRate: map['etfTodayResultRate'] == null? 0.0 : map['etfTodayResultRate'].toDouble(),
        etfRsvBuyRate: map['etfRsvBuyRate'] == null? 0.0 : map['etfRsvBuyRate'].toDouble(),
        etfRsvBuyPrc: map['etfRsvBuyPrc'] == null? 0.0 : map['etfRsvBuyPrc'].toDouble(),
        etfStockGroup: map['etfStockGroup'],
        etfStockType: map['etfStockType']

  );
}

  factory EtfStockInfo.fromInitJson(){
    //, {this.reference})
    return EtfStockInfo(
      etfStockDate: null,
      etfBfStockDate: null,
      etfStockId: null,
      etfStockName: null,
      etfBefClosePrice: 0.0,
      etfOpenPrice: 0.0,
      etfHighPrice: 0.0,
      etfLowPrice : 0.0,
      etfClosePrice : 0.0,
      etfTodayDiffPrice : 0.0,
      etfUdRateRealByToday: 0.0,
      etfUdRateRealByOpen : 0.0,
      etfUdRateRealByClose: 0.0,
      etfUdRateRealByLow: 0.0,
      etfUdRateRealByHigh : 0.0,
      beforeEtfOpenDoYn: 'N',
      afterEtfOpenDoYn: 'N',
      closeEtfOpenDoYn: 'N',
      etfMonthAggregateRate: 0.0,
      etfMonthAggregatePrice: 0.0,
      etfYearAggregateRate: 0.0,
      etfYearAggregatePrice: 0.0,
      etfTodayConclYn: 'N',
      etfTodayResultRate: 0.0,
      etfRsvBuyRate: 0.0,
      etfRsvBuyPrc: 0.0,
      etfStockGroup: null,
      etfStockType: null
    );
  }

  Map<String, dynamic> toJson() => {
    'etfStockDate': etfStockDate,
    'etfBfStockDate': etfBfStockDate,
    'etfStockId': etfStockId,
    'etfStockName': etfStockName,
    'etfBefClosePrice': etfBefClosePrice == null? 0.0 : etfBefClosePrice.toDouble(),
    'etfOpenPrice': etfOpenPrice == null? 0.0 : etfOpenPrice.toDouble(),
    'etfHighPrice': etfHighPrice == null? 0.0 : etfHighPrice.toDouble(),
    'etfLowPrice': etfLowPrice == null? 0.0 : etfLowPrice.toDouble(),
    'etfClosePrice': etfClosePrice == null? 0.0 : etfClosePrice.toDouble(),
    'etfTodayDiffPrice': etfTodayDiffPrice == null? 0.0 : etfTodayDiffPrice.toDouble(),
    'etfUdRateRealByToday': etfUdRateRealByToday == null? 0.0 : etfUdRateRealByToday.toDouble(),
    'etfUdRateRealByOpen': etfUdRateRealByOpen == null? 0.0 : etfUdRateRealByOpen.toDouble(),
    'etfUdRateRealByClose': etfUdRateRealByClose == null? 0.0 : etfUdRateRealByClose.toDouble(),
    'etfUdRateRealByLow': etfUdRateRealByLow == null? 0.0 : etfUdRateRealByLow.toDouble(),
    'etfUdRateRealByHigh': etfUdRateRealByHigh == null? 0.0 : etfUdRateRealByHigh.toDouble(),
    'beforeEtfOpenDoYn': beforeEtfOpenDoYn,
    'afterEtfOpenDoYn': afterEtfOpenDoYn,
    'closeEtfOpenDoYn': closeEtfOpenDoYn,
    'etfMonthAggregateRate': etfMonthAggregateRate == null? 0.0 : etfMonthAggregateRate.toDouble(),
    'etfMonthAggregatePrice': etfMonthAggregatePrice == null? 0.0 : etfMonthAggregatePrice.toDouble(),
    'etfYearAggregateRate': etfYearAggregateRate == null? 0.0 : etfYearAggregateRate.toDouble(),
    'etfYearAggregatePrice': etfYearAggregatePrice == null? 0.0 : etfYearAggregatePrice.toDouble(),
    'etfTodayConclYn': etfTodayConclYn,
    'etfTodayResultRate': etfTodayResultRate == null? 0.0 : etfTodayResultRate.toDouble(),
    'etfRsvBuyRate': etfRsvBuyRate == null? 0.0 : etfRsvBuyRate.toDouble(),
    'etfRsvBuyPrc': etfRsvBuyPrc == null? 0.0 : etfRsvBuyPrc.toDouble(),
    'etfStockGroup': etfStockGroup,
    'etfStockType': etfStockType
  };
  /*MarketInfo.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);*/

  /*@override
  String toString() => 'MarketInfo<$kspStockDate:$keyword>';*/

}