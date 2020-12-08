# ym_flutter_integration 
![Image of Yellowmessenger](https://yellowmessenger.com/wp-content/uploads/2020/08/Frame.png)

A Flutter plugin for integrating Yellow Messenger chatbots in your flutter application
## Overview 
Gives a widget to show chatbot on your mobile application, and listen to the events emitted from the chatbot 
## Usage
To use this plugin, add ym_flutter_integration as a dependency in your pubspec.yaml file.
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
## Methods
* `setConfig(...) ` : To set initial configurations to the chatbot ( Config should be added befioring callign the `getBotWidget(...)`)
* `getBotWidget(...)` : To get the chatbot widget
* `closeBot(...)` : close the chatbot
* `addPayload(...)` : add the payload to the chatbot ( payload is sent to chatbot once the `updatePayload` is called)
* `updatePayload(...)` : to send the added payload to the chatbot
* `clearPayload(...)` : To delete all exsting a nd added payloads
### SetConfig(...)
#### Flags
* `botId` (@required) [String]: Chatbot unique id to show in the widget
* `context` (@required) [BuildContext]: Context of the widget where you are showing the chatbot
* `enableHistory` [bool]: Enable prvious chat history of the chatobt
* `enableSpeech` [bool]: Enable the mic on the chatbot
* `enableCloseBot` [bool]: Close button to close the widget where chatbot is opened
Example:
```dart
String botId = "<Your bot id goes here>";
BuildContext context = <Widget context>;
bool enableHistory = false;
bool enableSpeech = false;
bool enableCloseButton = false;
ymBotSdk.setConfig
(   botId,
    context,
    enableHistory,
    enableSpeech,
    enableCloseButton);
```
### getBotWidget(...)
#### Flags
* `botEventListener` [Function(BotEvent )] : Bot emitted events are caught here 
Example:
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
