import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'BotViewWidget.dart';
import 'models/BotConfig.dart';
import 'models/BotPayload.dart';
import 'models/botEvents.dart';

// restricting the use of listen argument type
typedef BotEventListener = void Function(BotEvent);

class YmFlutterIntegration {
// -> Singleton class
  YmFlutterIntegration._internal();
  static final YmFlutterIntegration _ymFlutterIntegration =
      YmFlutterIntegration._internal();

  /// A singleton class for which configurations are set only once and referred to get same object again and again
  ///
  /// Note : Following values must be initialised before calling the widget
  /// * setConfig(...)
  /// * setPayload(...) if any
  ///
  /// {@tool snippet}
  /// Here is simple starter boiler plate
  /// ```dart
  /// class myImplementation
  /// {
  ///     YmFlutterIntegration ymBotSdk=YmBotSdk();
  ///     YmFlutterIntegration.setConfig(...);
  ///     YmFlutterIntegration.addPayload(...);
  /// }
  /// ```
  /// {@end-tool}
  factory YmFlutterIntegration() {
    return _ymFlutterIntegration;
  }
  //ends here

  // Set bot configuration for whihc the bot widget is thrown
  BotConfig myBotConfig = new BotConfig();
  BotPayload myBotPayload = new BotPayload();
  BuildContext context;
  String botId;
  bool enableHistory = false;
  String payloadJSON = "";
  String botUrl;
  bool speechServiceAvailability = false;

  // -> controller to control the webview
  WebViewController webViewController;
  SpeechToText stt = SpeechToText();

  // -> Speech releated varibles
  String speechResult;
  bool sendData = false;

  // -> Image related data
  String postImageUrl = "https://app.yellowmessenger.com/api/chat/upload?bot=";

  /// setConfig sets the default configuration for the chatbot.
  ///
  /// * String [botId] is the unique id assigned to your chatbot, which your are trying to show in the widget.
  /// * bool [enableHistory] is used to show previous chat history. It is set false by default.
  /// * bool [enableSpeech] is used to enable speech recognition on the chatbot. It is set false by default.
  /// * bool [enableCloseButton] is used to enable close button for the chatbot. It is set true by default.
  void setConfig({
    @required String botId,
    @required BuildContext context,
    bool enableHistory,
    bool enableSpeech,
    bool enableCloseButton,
  }) {
    this.myBotConfig = new BotConfig.setConfig(
        context: context,
        botId: botId,
        enableHistory: enableHistory,
        enableSpeech: enableSpeech,
        enableCloseButton: enableCloseButton);
  }

  /// Widget returns the bot widget itself
  /// Function(BotEvent) [BotEventListener] listens to the events emitted from the chatbot
  ///
  /// {@tool snippet}
  ///
  /// Here is simple boiler plate
  /// ```dart
  /// botEventListener: (BotEvent botEvent) {
  ///                   switch (botEvent.code) {
  ///                     case "event1":
  ///                       print(
  ///                           "code is ${botEvent.code}, data is ${botEvent.data}");
  ///                       break;
  ///                     default:
  ///                       print("No data");
  ///                   }
  ///                 },
  ///```
  /// {@end-tool}
  Widget getBotWidget({@required BotEventListener botEventListener}) {
    return BotViewWidget(
      myBotConfig: myBotConfig,
      setWebController: _setWebController,
      customEventListener: botEventListener,
      myBotPayload: myBotPayload,
    );
  }

  /// Closes the chatbot and stops listening the bot events
  void closeBot() {
    Navigator.pop(myBotConfig.context);
  }

  void sendEvent({@required String data}) async {
    try {
      print(await webViewController.currentUrl());
      await webViewController
          .evaluateJavascript("sendEvent(\"" + data + "\");");
    } catch (exception) {
      print(exception);
    }
  }

  _setWebController(WebViewController controller) {
    webViewController = controller;
  }

  /// Adds the payload to the chatbot.
  /// Will send/update the payload once updatePayload is called
  ///
  /// Note : not required to call updatePayload before calling the widget
  ///
  /// {@tool snippet}
  /// Here is an example
  /// ```dart
  /// class myImplementation
  /// {
  ///     YmFlutterIntegration ymFlutterIntegration=YmBotSdk();
  ///     YmFlutterIntegration.addPayload(key:"Name",value:"Yellowmessenger");
  ///     YmFlutterIntegration.updatePayload();
  /// }
  /// ```
  /// {@end-tool}
  void addPayload({@required String key, @required String value}) {
    // -> adds payload to BotPayload model for sending payload to the bot
    myBotPayload.add(key: key, value: value);
    // print(myBotPayload.getBotPayload());
  }

  /// updates about the current payload to the chatbot
  void updatePayload() {
    webViewController
        .loadUrl(myBotConfig.botUrl + myBotPayload.getBotPayload());
  }

  /// Clear existing payload
  void clearPayload() {
    myBotPayload = new BotPayload();
  }
}
