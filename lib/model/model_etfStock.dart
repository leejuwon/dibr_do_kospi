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
  final double etfMonthAggregatePriceV3;
  final double etfMonthAggregatePriceV5;
  final double etfYearAggregateRate;
  final double etfYearAggregatePrice;
  final double etfYearAggregatePriceV3;
  final double etfYearAggregatePriceV5;
  final String etfTodayConclYn;
  final double etfTodayResultRate;
  final double etfRsvBuyRate;
  final double etfRsvBuyPrc;
  final String etfStockGroup;
  final String etfStockType;
  final double etfTodayResultRevenue;
  final double etfTodayResultRevenueV3;
  final double etfTodayResultRevenueV5;
  final double etfMonthSimpleAggrPrice;
  final double etfMonthSimpleAggrPriceV3;
  final double etfMonthSimpleAggrPriceV5;
  final double etfYearSimpleAggrPrice;
  final double etfYearSimpleAggrPriceV3;
  final double etfYearSimpleAggrPriceV5;

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
    this.etfMonthAggregatePriceV3,
    this.etfMonthAggregatePriceV5,
    this.etfYearAggregateRate,
    this.etfYearAggregatePrice,
    this.etfYearAggregatePriceV3,
    this.etfYearAggregatePriceV5,
    this.etfMonthSimpleAggrPrice,
    this.etfMonthSimpleAggrPriceV3,
    this.etfMonthSimpleAggrPriceV5,
    this.etfYearSimpleAggrPrice,
    this.etfYearSimpleAggrPriceV3,
    this.etfYearSimpleAggrPriceV5,
    this.etfTodayConclYn,
    this.etfTodayResultRate,
    this.etfRsvBuyRate,
    this.etfRsvBuyPrc,
    this.etfStockGroup,
    this.etfStockType,
    this.etfTodayResultRevenue,
    this.etfTodayResultRevenueV3,
    this.etfTodayResultRevenueV5
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
        etfMonthAggregatePriceV3: map['etfMonthAggregatePriceV3'] == null? 0.0 : map['etfMonthAggregatePriceV3'].toDouble(),
        etfMonthAggregatePriceV5: map['etfMonthAggregatePriceV5'] == null? 0.0 : map['etfMonthAggregatePriceV5'].toDouble(),
        etfYearAggregateRate: map['etfYearAggregateRate'] == null? 0.0 : map['etfYearAggregateRate'].toDouble(),
        etfYearAggregatePrice: map['etfYearAggregatePrice'] == null? 0.0 : map['etfYearAggregatePrice'].toDouble(),
        etfYearAggregatePriceV3: map['etfYearAggregatePriceV3'] == null? 0.0 : map['etfYearAggregatePriceV3'].toDouble(),
        etfYearAggregatePriceV5: map['etfYearAggregatePriceV5'] == null? 0.0 : map['etfYearAggregatePriceV5'].toDouble(),
        etfTodayConclYn: map['etfTodayConclYn'],
        etfTodayResultRate: map['etfTodayResultRate'] == null? 0.0 : map['etfTodayResultRate'].toDouble(),
        etfRsvBuyRate: map['etfRsvBuyRate'] == null? 0.0 : map['etfRsvBuyRate'].toDouble(),
        etfRsvBuyPrc: map['etfRsvBuyPrc'] == null? 0.0 : map['etfRsvBuyPrc'].toDouble(),
        etfStockGroup: map['etfStockGroup'],
        etfStockType: map['etfStockType'],
        etfMonthSimpleAggrPrice: map['etfMonthSimpleAggrPrice'] == null? 0.0 : map['etfMonthSimpleAggrPrice'].toDouble(),
        etfMonthSimpleAggrPriceV3: map['etfMonthSimpleAggrPriceV3'] == null? 0.0 : map['etfMonthSimpleAggrPriceV3'].toDouble(),
        etfMonthSimpleAggrPriceV5: map['etfMonthSimpleAggrPriceV5'] == null? 0.0 : map['etfMonthSimpleAggrPriceV5'].toDouble(),
        etfYearSimpleAggrPrice: map['etfYearSimpleAggrPrice'] == null? 0.0 : map['etfYearSimpleAggrPrice'].toDouble(),
        etfYearSimpleAggrPriceV3: map['etfYearSimpleAggrPriceV3'] == null? 0.0 : map['etfYearSimpleAggrPriceV3'].toDouble(),
        etfYearSimpleAggrPriceV5: map['etfYearSimpleAggrPriceV5'] == null? 0.0 : map['etfYearSimpleAggrPriceV5'].toDouble(),
        etfTodayResultRevenue: map['etfTodayResultRevenue'] == null? 0.0 : map['etfTodayResultRevenue'].toDouble(),
        etfTodayResultRevenueV3: map['etfTodayResultRevenueV3'] == null? 0.0 : map['etfTodayResultRevenueV3'].toDouble(),
        etfTodayResultRevenueV5: map['etfTodayResultRevenueV5'] == null? 0.0 : map['etfTodayResultRevenueV5'].toDouble()

    );
  }

  factory EtfStockInfo.fromInitJson(){
    //, {this.reference})
    return EtfStockInfo(
        etfStockDate: "",
        etfBfStockDate: "",
        etfStockId: "",
        etfStockName: "",
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
        etfMonthAggregatePriceV3: 0.0,
        etfMonthAggregatePriceV5: 0.0,
        etfYearAggregateRate: 0.0,
        etfYearAggregatePrice: 0.0,
        etfYearAggregatePriceV3: 0.0,
        etfYearAggregatePriceV5: 0.0,
        etfTodayConclYn: 'N',
        etfTodayResultRate: 0.0,
        etfRsvBuyRate: 0.0,
        etfRsvBuyPrc: 0.0,
        etfStockGroup: null,
        etfStockType: null,
        etfMonthSimpleAggrPrice: 0.0,
        etfMonthSimpleAggrPriceV3: 0.0,
        etfMonthSimpleAggrPriceV5: 0.0,
        etfYearSimpleAggrPrice: 0.0,
        etfYearSimpleAggrPriceV3: 0.0,
        etfYearSimpleAggrPriceV5: 0.0,
        etfTodayResultRevenue: 0.0,
        etfTodayResultRevenueV3: 0.0,
        etfTodayResultRevenueV5: 0.0
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
    'etfMonthAggregatePriceV3': etfMonthAggregatePriceV3 == null? 0.0 : etfMonthAggregatePriceV3.toDouble(),
    'etfMonthAggregatePriceV5': etfMonthAggregatePriceV5 == null? 0.0 : etfMonthAggregatePriceV5.toDouble(),
    'etfYearAggregateRate': etfYearAggregateRate == null? 0.0 : etfYearAggregateRate.toDouble(),
    'etfYearAggregatePrice': etfYearAggregatePrice == null? 0.0 : etfYearAggregatePrice.toDouble(),
    'etfYearAggregatePriceV3': etfYearAggregatePriceV3 == null? 0.0 : etfYearAggregatePriceV3.toDouble(),
    'etfYearAggregatePriceV5': etfYearAggregatePriceV5 == null? 0.0 : etfYearAggregatePriceV5.toDouble(),
    'etfTodayConclYn': etfTodayConclYn,
    'etfTodayResultRate': etfTodayResultRate == null? 0.0 : etfTodayResultRate.toDouble(),
    'etfRsvBuyRate': etfRsvBuyRate == null? 0.0 : etfRsvBuyRate.toDouble(),
    'etfRsvBuyPrc': etfRsvBuyPrc == null? 0.0 : etfRsvBuyPrc.toDouble(),
    'etfStockGroup': etfStockGroup,
    'etfStockType': etfStockType,
    'etfMonthSimpleAggrPrice': etfMonthSimpleAggrPrice == null? 0.0 : etfMonthSimpleAggrPrice.toDouble(),
    'etfMonthSimpleAggrPriceV3': etfMonthSimpleAggrPriceV3 == null? 0.0 : etfMonthSimpleAggrPriceV3.toDouble(),
    'etfMonthSimpleAggrPriceV5': etfMonthSimpleAggrPriceV5 == null? 0.0 : etfMonthSimpleAggrPriceV5.toDouble(),
    'etfYearSimpleAggrPrice': etfYearSimpleAggrPrice == null? 0.0 : etfYearSimpleAggrPrice.toDouble(),
    'etfYearSimpleAggrPriceV3': etfYearSimpleAggrPriceV3 == null? 0.0 : etfYearSimpleAggrPriceV3.toDouble(),
    'etfYearSimpleAggrPriceV5': etfYearSimpleAggrPriceV5 == null? 0.0 : etfYearSimpleAggrPriceV5.toDouble(),
    'etfTodayResultRevenue': etfTodayResultRevenue == null? 0.0 : etfTodayResultRevenue.toDouble(),
    'etfTodayResultRevenueV3': etfTodayResultRevenueV3 == null? 0.0 : etfTodayResultRevenueV3.toDouble(),
    'etfTodayResultRevenueV5': etfTodayResultRevenueV5 == null? 0.0 : etfTodayResultRevenueV5.toDouble()
  };
/*MarketInfo.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);*/

/*@override
  String toString() => 'MarketInfo<$kspStockDate:$keyword>';*/

}