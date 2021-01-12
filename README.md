# ym_flutter_integration 
![Image of Yellowmessenger](https://yellowmessenger.com/wp-content/uploads/2020/08/Frame.png)

A Flutter plugin for integrating Yellow Messenger chatbots in your flutter application
## Overview 
Gives a widget to show chatbot on your mobile application, and listen to the events emitted from the chatbot 
## Usage
To use this plugin, add ym_flutter_integration as a dependency in your pubspec.yaml file.
## Getting started
Initialise the ym_flutter_integration and set the initial configurations 
```dart
import 'package:flutter/material.dart';
import 'package:ym_flutter_integration/models/botEvents.dart';
import 'package:ym_flutter_integration/ym_flutter_integration.dart';
 class _BotPageState extends State<BotPage> {
  YmFlutterIntegration ymFlutterIntegration;
  String botId = "<Your botId goes here>";
  @override
  void initState() {
    super.initState();
    ymFlutterIntegration = YmFlutterIntegration();
    ymFlutterIntegration.setConfig(
        context: context,
        botId: botId,
        enableHistory: false,
        enableSpeech: false,
        enableCloseButton: true);
  }
 }
```
Call getBotWidget() method on the **ymFlutterIntegration** object to get the chatbot widget
```dart
ymFlutterIntegration.getBotWidget(
            botEventListener: (BotEvent botEvent) {
              switch (botEvent.code) {
                case "event1":
                  ymFlutterIntegration.closeBot();
                  print("code is ${botEvent.code}, data");
                  print("is ${botEvent.data}");
                  break;
                default:
                  print("No data");
              }
            },
          ),
```
## Requirements

### Android

```
build.grable

  minSdkVersion : 21

permissions

    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```
## IOS

```
info.plist

<key>NSMicrophoneUsageDescription</key>
<string>Speech recognisation is used to understand user speech and send data to chat bot running on plugin</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>Speech recognisation is used to understand user speech and send data to chat bot running on plugin</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
```


## Methods
* `setConfig(...) ` : To set initial configurations to the chatbot ( Config should be added befioring callign the `getBotWidget(...)`)
* `getBotWidget(...)` : To get the chatbot widget
* `closeBot(...)` : close the chatbot
* `addPayload(...)` : add the payload to the chatbot ( payload is sent to chatbot once the `updatePayload` is called)
* `updatePayload(...)` : to send the added payload to the chatbot
* `clearPayload(...)` : To delete all exsting a nd added payloads


### setConfig(...)
#### Flags
* `botId` (@required) [String]: Chatbot unique id to show in the widget
* `context` (@required) [BuildContext]: Context of the widget where you are showing the chatbot
* `enableHistory` [bool]: Enable previous chat history of the chatobt
* `enableSpeech` [bool]: Enable speech recognition on the chatbot
* `enableCloseBot` [bool]: Close button to close the widget where chatbot is opened
Example:
```dart
String botId = "<Your bot id goes here>";
BuildContext context = <Widget context>;
bool enableHistory = false;
bool enableSpeech = false;
bool enableCloseButton = false;
ymFlutterIntegration.setConfig
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
ymFlutterIntegration.getBotWidget(
            botEventListener: (BotEvent botEvent) {
              switch (botEvent.code) {
                case "event1":
                  ymFlutterIntegration.closeBot();
                  print("code is ${botEvent.code}, data");
                  print("is ${botEvent.data}");
                  break;
                default:
                  print("No data");
              }
            },
          ),
```


### closeBot()

Example:
```dart
ymFlutterIntegration.closeBot()
```

### addPayload(...)
#### Flags
* key (@required)[String]: Unique name given to payload item
* value (@required) [dynamic]: Value associated to the key

Example:
```dart
ymFlutterIntegration.addPayload(key:"Name",value:"Purush");
ymFlutterIntegration.addPayload(key:"company",value:"Yellowmessenger");
```

### updatePayload()
```dart
ymFlutterIntegration.updatePayload();
```

### clearPayload()

```dart
ymFlutterIntegration.clearPayload();
```