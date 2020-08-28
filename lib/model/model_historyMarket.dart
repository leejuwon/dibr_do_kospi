//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarketHistInfo {
  final String kspStockDate;
  final String kspBfStockDate;
  final double kspBefClosePrice;
  final double kspOpenPrice;
  final double kspHighPrice;
  final double kspLowPrice ;
  final double kspClosePrice ;
  final double kspTodayDiffPrice ;
  final double kspUdRateRealByToday;
  final double kspUdRateRealByOpen ;
  final double kspUdRateRealByClose;
  final double kspUdRateRealByLow;
  final double kspUdRateRealByHigh ;
  final double snpStdPrice ;
  final double snpEndPrice ;
  final double snpUdPrice;
  final double snpUdRateRealByClose;
  final double snpScore;
  final double eurStdPrice ;
  final double eurEndPrice ;
  final double eurUdPrice;
  final double eurUdRateRealByClose;
  final double eurScore;
  final double wtiStdPrice ;
  final double wtiEndPrice ;
  final double wtiUdPrice;
  final double wtiUdRateRealByClose;
  final double dubStdPrice ;
  final double dubEndPrice ;
  final double dubUdPrice;
  final double dubUdRateRealByClose;
  final double breStdPrice ;
  final double breEndPrice ;
  final double breUdPrice;
  final double breUdRateRealByClose;
  final double oilScore;
  final double wtiScore;
  final double dubScore;
  final double breScore;
  final double bfStdRate ;
  final double tdOpRate;
  final double excDiffPrice;
  final double excDiffRate ;
  final double exRauTotScore ;
  final double totScore1st ;
  final double excScore1st ;
  final int exRauTotScoreGrade;
  final int excSetRngGrp;
  final String excSetType;
  final String wtiOpenDoYn;
  final String dubOpenDoYn;
  final String breOpenDoYn;
  final String snpOpenDoYn;
  final String eurOpenDoYn;
  final String bfExcOpenDoYn;
  final String afExcOpenDoYn;
  final String bfKspOpenDoYn;
  final String afKspOpenDoYn;
  final String closeKspOpenDoYn;

  final String buyType1st;
  final String buyType2nd;
  final String otType;
  final int plus1st;
  final int plus2nd;
  final String defaultType1st;
  final String defaultType2nd;
  final int minusDecide1st;
  final int minusDecide2nd;
  final double otPow2nd;
  final String selectStock;
  final double revDevRate;
  final double invDevRate;
  final double buyRate1st;
  final double buyRate2nd;
  //final DocumentReference reference;

  MarketHistInfo({
    this.kspStockDate,
    this.kspBfStockDate,
    this.kspBefClosePrice,
    this.kspOpenPrice,
    this.kspHighPrice,
    this.kspLowPrice,
    this.kspClosePrice,
    this.kspTodayDiffPrice,
    this.kspUdRateRealByToday,
    this.kspUdRateRealByOpen,
    this.kspUdRateRealByClose,
    this.kspUdRateRealByLow,
    this.kspUdRateRealByHigh,
    this.snpStdPrice,
    this.snpEndPrice,
    this.snpUdPrice,
    this.snpUdRateRealByClose,
    this.snpScore,
    this.eurStdPrice,
    this.eurEndPrice,
    this.eurUdPrice,
    this.eurUdRateRealByClose,
    this.eurScore,
    this.wtiStdPrice,
    this.wtiEndPrice,
    this.wtiUdPrice,
    this.wtiUdRateRealByClose,
    this.dubStdPrice,
    this.dubEndPrice,
    this.dubUdPrice,
    this.dubUdRateRealByClose,
    this.breStdPrice,
    this.breEndPrice,
    this.breUdPrice,
    this.breUdRateRealByClose,
    this.oilScore,
    this.wtiScore,
    this.dubScore,
    this.breScore,
    this.bfStdRate,
    this.tdOpRate,
    this.excDiffPrice,
    this.excDiffRate,
    this.exRauTotScore,
    this.totScore1st,
    this.excScore1st,
    this.exRauTotScoreGrade,
    this.excSetRngGrp,
    this.wtiOpenDoYn,
    this.dubOpenDoYn,
    this.breOpenDoYn,
    this.snpOpenDoYn,
    this.eurOpenDoYn,
    this.bfExcOpenDoYn,
    this.afExcOpenDoYn,
    this.bfKspOpenDoYn,
    this.afKspOpenDoYn,
    this.closeKspOpenDoYn,
    this.excSetType,
    this.buyType1st,
    this.buyType2nd,
    this.otType,
    this.plus1st,
    this.plus2nd,
    this.defaultType1st,
    this.defaultType2nd,
    this.minusDecide1st,
    this.minusDecide2nd,
    this.otPow2nd,
    this.selectStock,
    this.revDevRate,
    this.invDevRate,
    this.buyRate1st,
    this.buyRate2nd
  });

  factory MarketHistInfo.fromJson(Map<String, dynamic> map){
        //, {this.reference})
      return MarketHistInfo(
          kspStockDate: map['kspStockDate'],
          kspBfStockDate: map['kspBfStockDate'],
          kspBefClosePrice: map['kspBefClosePrice'] == null? 0.0 : map['kspBefClosePrice'].toDouble(),
          kspOpenPrice: map['kspOpenPrice'] == null? 0.0 : map['kspOpenPrice'].toDouble(),
          kspHighPrice: map['kspHighPrice'] == null? 0.0 : map['kspHighPrice'].toDouble(),
          kspLowPrice: map['kspLowPrice'] == null? 0.0 : map['kspLowPrice'].toDouble(),
          kspClosePrice: map['kspClosePrice'] == null? 0.0 : map['kspClosePrice'].toDouble(),
          kspTodayDiffPrice: map['kspTodayDiffPrice'] == null? 0.0 : map['kspTodayDiffPrice'].toDouble(),
          kspUdRateRealByToday: map['kspUdRateRealByToday'] == null? 0.0 : map['kspUdRateRealByToday'].toDouble(),
          kspUdRateRealByOpen: map['kspUdRateRealByOpen'] == null? 0.0 : map['kspUdRateRealByOpen'].toDouble(),
          kspUdRateRealByClose: map['kspUdRateRealByClose'] == null? 0.0 : map['kspUdRateRealByClose'].toDouble(),
          kspUdRateRealByLow: map['kspUdRateRealByLow'] == null? 0.0 : map['kspUdRateRealByLow'].toDouble(),
          kspUdRateRealByHigh: map['kspUdRateRealByHigh'] == null? 0.0 : map['kspUdRateRealByHigh'].toDouble(),
          snpStdPrice: map['snpStdPrice'] == null? 0.0 : map['snpStdPrice'].toDouble(),
          snpEndPrice: map['snpEndPrice'] == null? 0.0 : map['snpEndPrice'].toDouble(),
          snpUdPrice: map['snpUdPrice'] == null? 0.0 : map['snpUdPrice'].toDouble(),
          snpUdRateRealByClose: map['snpUdRateRealByClose'] == null? 0.0 : map['snpUdRateRealByClose'].toDouble(),
          snpScore: map['snpScore'] == null? 0.0 : map['snpScore'].toDouble(),
          eurStdPrice: map['eurStdPrice'] == null? 0.0 : map['eurStdPrice'].toDouble(),
          eurEndPrice: map['eurEndPrice'] == null? 0.0 : map['eurEndPrice'].toDouble(),
          eurUdPrice: map['eurUdPrice'] == null? 0.0 : map['eurUdPrice'].toDouble(),
          eurUdRateRealByClose: map['eurUdRateRealByClose'] == null? 0.0 : map['eurUdRateRealByClose'].toDouble(),
          eurScore: map['eurScore'] == null? 0.0 : map['eurScore'].toDouble(),
          wtiStdPrice: map['wtiStdPrice'] == null? 0.0 : map['wtiStdPrice'].toDouble(),
          wtiEndPrice: map['wtiEndPrice'] == null? 0.0 : map['wtiEndPrice'].toDouble(),
          wtiUdPrice: map['wtiUdPrice'] == null? 0.0 : map['wtiUdPrice'].toDouble(),
          wtiUdRateRealByClose: map['wtiUdRateRealByClose'] == null? 0.0 : map['wtiUdRateRealByClose'].toDouble(),
          dubStdPrice: map['dubStdPrice'] == null? 0.0 : map['dubStdPrice'].toDouble(),
          dubEndPrice: map['dubEndPrice'] == null? 0.0 : map['dubEndPrice'].toDouble(),
          dubUdPrice: map['dubUdPrice'] == null? 0.0 : map['dubUdPrice'].toDouble(),
          dubUdRateRealByClose: map['dubUdRateRealByClose'] == null? 0.0 : map['dubUdRateRealByClose'].toDouble(),
          breStdPrice: map['breStdPrice'] == null? 0.0 : map['breStdPrice'].toDouble(),
          breEndPrice: map['breEndPrice'] == null? 0.0 : map['breEndPrice'].toDouble(),
          breUdPrice: map['breUdPrice'] == null? 0.0 : map['breUdPrice'].toDouble(),
          breUdRateRealByClose: map['breUdRateRealByClose'] == null? 0.0 : map['breUdRateRealByClose'].toDouble(),
          oilScore: map['oilScore'] == null? 0.0 : map['oilScore'].toDouble(),
          wtiScore: map['wtiScore'] == null? 0.0 : map['wtiScore'].toDouble(),
          dubScore: map['dubScore'] == null? 0.0 : map['dubScore'].toDouble(),
          breScore: map['breScore'] == null? 0.0 : map['breScore'].toDouble(),
          bfStdRate: map['bfStdRate'] == null? 0.0 : map['bfStdRate'].toDouble(),
          tdOpRate: map['tdOpRate'] == null? 0.0 : map['tdOpRate'].toDouble(),
          excDiffPrice: map['excDiffPrice'] == null? 0.0 : map['excDiffPrice'].toDouble(),
          excDiffRate: map['excDiffRate'] == null? 0.0 : map['excDiffRate'].toDouble(),
          exRauTotScore: map['exRauTotScore'] == null? 0.0 : map['exRauTotScore'].toDouble(),
          totScore1st: map['totScore1st'] == null? 0.0 : map['totScore1st'].toDouble(),
          excScore1st: map['excScore1st'] == null? 0.0 : map['excScore1st'].toDouble(),
          exRauTotScoreGrade: map['exRauTotScoreGrade'],
          excSetRngGrp: map['excSetRngGrp'],
          wtiOpenDoYn: map['wtiOpenDoYn'],
          dubOpenDoYn: map['dubOpenDoYn'],
          breOpenDoYn: map['breOpenDoYn'],
          snpOpenDoYn: map['snpOpenDoYn'],
          eurOpenDoYn: map['eurOpenDoYn'],
          bfExcOpenDoYn: map['bfExcOpenDoYn'],
          afExcOpenDoYn: map['afExcOpenDoYn'],
          bfKspOpenDoYn: map['bfKspOpenDoYn'],
          afKspOpenDoYn: map['afKspOpenDoYn'],
          closeKspOpenDoYn: map['closeKspOpenDoYn'],
          excSetType: map['excSetType'],
          buyType1st: map['buyType1st'],
          buyType2nd: map['buyType2nd'],
          otType: map['otType'],
          plus1st: map['plus1st'],
          plus2nd: map['plus2nd'],
          defaultType1st: map['defaultType1st'],
          defaultType2nd: map['defaultType2nd'],
          minusDecide1st: map['minusDecide1st'],
          minusDecide2nd: map['minusDecide2nd'],
          otPow2nd: map['otPow2nd'] == null? 0.0 : map['otPow2nd'].toDouble(),
          selectStock: map['selectStock'],
          revDevRate: map['revDevRate'] == null? 0.0 : map['revDevRate'].toDouble(),
          invDevRate: map['invDevRate'] == null? 0.0 : map['invDevRate'].toDouble(),
          buyRate1st: map['buyRate1st'] == null? 0.0 : map['buyRate1st'].toDouble(),
          buyRate2nd: map['buyRate2nd'] == null? 0.0 : map['buyRate2nd'].toDouble()
  );
}

  factory MarketHistInfo.fromInitJson(){
    //, {this.reference})
    return MarketHistInfo(
        kspStockDate: null,
        kspBfStockDate: null,
        kspBefClosePrice: 0.0,
        kspOpenPrice: 0.0,
        kspHighPrice: 0.0,
        kspLowPrice: 0.0,
        kspClosePrice: 0.0,
        kspTodayDiffPrice: 0.0,
        kspUdRateRealByToday: 0.0,
        kspUdRateRealByOpen: 0.0,
        kspUdRateRealByClose: 0.0,
        kspUdRateRealByLow: 0.0,
        kspUdRateRealByHigh: 0.0,
        snpStdPrice: 0.0,
        snpEndPrice: 0.0,
        snpUdPrice: 0.0,
        snpUdRateRealByClose: 0.0,
        snpScore: 0.0,
        eurStdPrice: 0.0,
        eurEndPrice: 0.0,
        eurUdPrice: 0.0,
        eurUdRateRealByClose: 0.0,
        eurScore: 0.0,
        wtiStdPrice: 0.0,
        wtiEndPrice: 0.0,
        wtiUdPrice: 0.0,
        wtiUdRateRealByClose: 0.0,
        dubStdPrice: 0.0,
        dubEndPrice: 0.0,
        dubUdPrice: 0.0,
        dubUdRateRealByClose: 0.0,
        breStdPrice: 0.0,
        breEndPrice: 0.0,
        breUdPrice: 0.0,
        breUdRateRealByClose: 0.0,
        oilScore: 0.0,
        wtiScore: 0.0,
        dubScore: 0.0,
        breScore: 0.0,
        bfStdRate: 0.0,
        tdOpRate: 0.0,
        excDiffPrice: 0.0,
        excDiffRate: 0.0,
        exRauTotScore: 0.0,
        totScore1st: 0.0,
        excScore1st: 0.0,
        exRauTotScoreGrade: 0,
        excSetRngGrp: 0,
        wtiOpenDoYn: 'N',
        dubOpenDoYn: 'N',
        breOpenDoYn: 'N',
        snpOpenDoYn: 'N',
        eurOpenDoYn: 'N',
        bfExcOpenDoYn: 'N',
        afExcOpenDoYn: 'N',
        bfKspOpenDoYn: 'N',
        afKspOpenDoYn: 'N',
        closeKspOpenDoYn: 'N',
        excSetType: '',
        buyType1st: '',
        buyType2nd: '',
        otType: '',
        plus1st: 0,
        plus2nd: 0,
        defaultType1st: '',
        defaultType2nd: '',
        minusDecide1st: 0,
        minusDecide2nd: 0,
        otPow2nd: 0.0,
        selectStock: '',
        revDevRate: 0.0,
        invDevRate: 0.0,
        buyRate1st: 0.0,
        buyRate2nd: 0.0
    );
  }

  Map<String, dynamic> toJson() => {
    'kspStockDate': kspStockDate,
    'kspBfStockDate': kspBfStockDate,
    'kspBefClosePrice': kspBefClosePrice == null? 0.0 : kspBefClosePrice.toDouble(),
    'kspOpenPrice': kspOpenPrice == null? 0.0 : kspOpenPrice.toDouble(),
    'kspHighPrice': kspHighPrice == null? 0.0 : kspHighPrice.toDouble(),
    'kspLowPrice': kspLowPrice == null? 0.0 : kspLowPrice.toDouble(),
    'kspClosePrice': kspClosePrice == null? 0.0 : kspClosePrice.toDouble(),
    'kspTodayDiffPrice': kspTodayDiffPrice == null? 0.0 : kspTodayDiffPrice.toDouble(),
    'kspUdRateRealByToday': kspUdRateRealByToday == null? 0.0 : kspUdRateRealByToday.toDouble(),
    'kspUdRateRealByOpen': kspUdRateRealByOpen == null? 0.0 : kspUdRateRealByOpen.toDouble(),
    'kspUdRateRealByClose': kspUdRateRealByClose == null? 0.0 : kspUdRateRealByClose.toDouble(),
    'kspUdRateRealByLow': kspUdRateRealByLow == null? 0.0 : kspUdRateRealByLow.toDouble(),
    'kspUdRateRealByHigh': kspUdRateRealByHigh == null? 0.0 : kspUdRateRealByHigh.toDouble(),
    'snpStdPrice': snpStdPrice == null? 0.0 : snpStdPrice.toDouble(),
    'snpEndPrice': snpEndPrice == null? 0.0 : snpEndPrice.toDouble(),
    'snpUdPrice': snpUdPrice == null? 0.0 : snpUdPrice.toDouble(),
    'snpUdRateRealByClose': snpUdRateRealByClose == null? 0.0 : snpUdRateRealByClose.toDouble(),
    'snpScore': snpScore == null? 0.0 : snpScore.toDouble(),
    'eurStdPrice': eurStdPrice == null? 0.0 : eurStdPrice.toDouble(),
    'eurEndPrice': eurEndPrice == null? 0.0 : eurEndPrice.toDouble(),
    'eurUdPrice': eurUdPrice == null? 0.0 : eurUdPrice.toDouble(),
    'eurUdRateRealByClose': eurUdRateRealByClose == null? 0.0 : eurUdRateRealByClose.toDouble(),
    'eurScore': eurScore == null? 0.0 : eurScore.toDouble(),
    'wtiStdPrice': wtiStdPrice == null? 0.0 : wtiStdPrice.toDouble(),
    'wtiEndPrice': wtiEndPrice == null? 0.0 : wtiEndPrice.toDouble(),
    'wtiUdPrice': wtiUdPrice == null? 0.0 : wtiUdPrice.toDouble(),
    'wtiUdRateRealByClose': wtiUdRateRealByClose == null? 0.0 : wtiUdRateRealByClose.toDouble(),
    'dubStdPrice': dubStdPrice == null? 0.0 : dubStdPrice.toDouble(),
    'dubEndPrice': dubEndPrice == null? 0.0 : dubEndPrice.toDouble(),
    'dubUdPrice': dubUdPrice == null? 0.0 : dubUdPrice.toDouble(),
    'dubUdRateRealByClose': dubUdRateRealByClose == null? 0.0 : dubUdRateRealByClose.toDouble(),
    'breStdPrice': breStdPrice == null? 0.0 : breStdPrice.toDouble(),
    'breEndPrice': breEndPrice == null? 0.0 : breEndPrice.toDouble(),
    'breUdPrice': breUdPrice == null? 0.0 : breUdPrice.toDouble(),
    'breUdRateRealByClose': breUdRateRealByClose == null? 0.0 : breUdRateRealByClose.toDouble(),
    'oilScore': oilScore == null? 0.0 : oilScore.toDouble(),
    'wtiScore': wtiScore == null? 0.0 : wtiScore.toDouble(),
    'dubScore': dubScore == null? 0.0 : dubScore.toDouble(),
    'breScore': breScore == null? 0.0 : breScore.toDouble(),
    'bfStdRate': bfStdRate == null? 0.0 : bfStdRate.toDouble(),
    'tdOpRate': tdOpRate == null? 0.0 : tdOpRate.toDouble(),
    'excDiffPrice': excDiffPrice == null? 0.0 : excDiffPrice.toDouble(),
    'excDiffRate': excDiffRate == null? 0.0 : excDiffRate.toDouble(),
    'exRauTotScore': exRauTotScore == null? 0.0 : exRauTotScore.toDouble(),
    'totScore1st': totScore1st == null? 0.0 : totScore1st.toDouble(),
    'excScore1st': excScore1st == null? 0.0 : excScore1st.toDouble(),
    'exRauTotScoreGrade': exRauTotScoreGrade == null? 0 : exRauTotScoreGrade,
    'excSetRngGrp': excSetRngGrp == null? 0 : excSetRngGrp,
    'wtiOpenDoYn': wtiOpenDoYn,
    'dubOpenDoYn': dubOpenDoYn,
    'breOpenDoYn': breOpenDoYn,
    'snpOpenDoYn': snpOpenDoYn,
    'eurOpenDoYn': eurOpenDoYn,
    'bfExcOpenDoYn': bfExcOpenDoYn,
    'afExcOpenDoYn': afExcOpenDoYn,
    'bfKspOpenDoYn': bfKspOpenDoYn,
    'afKspOpenDoYn': afKspOpenDoYn,
    'closeKspOpenDoYn': closeKspOpenDoYn,
    'excSetType': excSetType,
    'buyType1st': buyType1st,
    'buyType2nd': buyType2nd,
    'otType': otType,
    'plus1st': plus1st,
    'plus2nd': plus2nd,
    'defaultType1st': defaultType1st,
    'defaultType2nd': defaultType2nd,
    'minusDecide1st': minusDecide1st,
    'minusDecide2nd': minusDecide2nd,
    'otPow2nd': otPow2nd == null? 0.0 : otPow2nd.toDouble(),
    'selectStock': selectStock,
    'revDevRate': revDevRate == null? 0.0 : revDevRate.toDouble(),
    'invDevRate': invDevRate == null? 0.0 : invDevRate.toDouble(),
    'buyRate1st': buyRate1st == null? 0.0 : buyRate1st.toDouble(),
    'buyRate2nd': buyRate2nd == null? 0.0 : buyRate2nd.toDouble()
  };
  /*MarketInfo.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);*/

  /*@override
  String toString() => 'MarketInfo<$kspStockDate:$keyword>';*/

}