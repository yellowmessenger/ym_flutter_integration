# YM Bot SDK

![Image of Yellowmessenger](https://yellowmessenger.com/wp-content/uploads/2020/08/Frame.png)

A Flutter plugin for integrating Yellow Messenger chatbots in your flutter application

## Overview 
Gives a widget to show chatbot on your mobile application, and listen to the events emitted from the chatbot 

## Usage
To use this plugin, add Ym_Bot_SDK as a dependency in your pubspec.yaml file.

## Getting started
Initialise the YmBotSdk and set the initial configurations 
```dart
import 'package:flutter/material.dart';
import 'package:ym_bot_sdk/models/botEvents.dart';
import 'package:ym_bot_sdk/ym_bot_sdk.dart';

 class _BotPageState extends State<BotPage> {
  YmBotSdk ymBotSdk;
  String botId = "<Your botId goes here>";

  @override
  void initState() {
    super.initState();

    ymBotSdk = YmBotSdk();
    ymBotSdk.setConfig(
        context: context,
        botId: botId,
        enableHistory: false,
        enableSpeech: false,
        enableCloseButton: true);
  }
 }

```

Call getBotWidget() method on the **ymBotSdk** object to get the chatbot widget

```dart
ymBotSdk.getBotWidget(
            botEventListener: (BotEvent botEvent) {
              switch (botEvent.code) {
                case "event1":
                  ymBotSdk.closeBot();
                  print("code is ${botEvent.code}, data");
                  print("is ${botEvent.data}");
                  break;
                default:
                  print("No data");
              }
            },
          ),
```
