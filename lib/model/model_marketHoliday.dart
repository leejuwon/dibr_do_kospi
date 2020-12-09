//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarketHolidayInfo {
  final String kspStockDate;
  
  //final DocumentReference reference;

  MarketHolidayInfo({
    this.kspStockDate
  });

  factory MarketHolidayInfo.fromJson(Map<String, dynamic> map){
    //, {this.reference})
    return MarketHolidayInfo(
        kspStockDate: map['kspStockDate']
    );
  }

  factory MarketHolidayInfo.fromInitJson(){
    //, {this.reference})
    return MarketHolidayInfo(
        kspStockDate: ""
    );
  }

  Map<String, dynamic> toJson() => {
    'etfStockDate': kspStockDate
  };
/*MarketInfo.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);*/

/*@override
  String toString() => 'MarketInfo<$kspStockDate:$keyword>';*/

}