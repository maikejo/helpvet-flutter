import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

EtherScanTransaction welcomeFromJson(String str) {
  final jsonData = json.decode(str);
  return EtherScanTransaction.fromJson(jsonData);
}

class EtherScanTransaction {
  final String status;
  final String message;
  final List<EtherScanResultTransaction> result;

  EtherScanTransaction({this.status, this.message , this.result});

  factory EtherScanTransaction.fromJson(Map<String, dynamic> json) {
    return EtherScanTransaction(
      status: json['status'],
      message: json['message'],
      result: List<EtherScanResultTransaction>.from(json["result"].map((x) => EtherScanResultTransaction.fromJson(x)))

    );
  }
}

class EtherScanResultTransaction {
  final String hash;
  final String value;

  EtherScanResultTransaction({this.hash, this.value});

  factory EtherScanResultTransaction.fromJson(Map<String, dynamic> json) {
    return EtherScanResultTransaction(
      hash: json['hash'],
      value: json['value'],
    );
  }
}