import 'dart:convert';

import 'package:flutter/material.dart';

class BotPayload {
  Map<String, dynamic> payload = Map<String, dynamic>();
  void add({@required String key, @required dynamic value}) {
    this.payload[key] = value;
  }

  String getBotPayload() {
    String temp = json.encode(this.payload).toString().replaceAll("\"", "%22");
    return "%7b${temp.substring(1, temp.length - 1)}%7d";
  }
}
