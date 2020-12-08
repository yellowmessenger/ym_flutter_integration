import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ym_flutter_integration/models/BotConfig.dart';
import 'package:ym_flutter_integration/models/BotPayload.dart';
import 'package:ym_flutter_integration/ym_bot_sdk.dart';

import 'models/botEvents.dart';

class BotViewWidget extends StatefulWidget {
  final BotConfig myBotConfig;
  Function setWebController, customEventListener;
  BotPayload myBotPayload;
  BotViewWidget(
      {this.myBotConfig,
      this.setWebController,
      @required this.myBotPayload,
      @required this.customEventListener});
  @override
  _BotViewWidgetState createState() => _BotViewWidgetState();
}

class _BotViewWidgetState extends State<BotViewWidget> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    String botUrl =
        '${widget.myBotConfig.botUrl}${widget.myBotPayload.getBotPayload()}';
    return Stack(
      children: <Widget>[
        WebView(
          initialUrl: botUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            widget.setWebController(webViewController);
          },
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
            _events(context, widget.customEventListener),
          ].toSet(),
          onWebResourceError: (error) {
            print(error);
          },
          navigationDelegate: (NavigationRequest request) async {
            print('request $request');
            if (request.url == "about:blank" ||
                request.url ==
                    widget.myBotConfig.botUrl +
                        widget.myBotPayload.getBotPayload()) {
              return NavigationDecision.navigate;
            } else if (await canLaunch(request.url)) {
              await launch(request.url);
              return NavigationDecision.prevent;
            } else {
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Unable to navigate to ${request.url}")),
              );
              return NavigationDecision.prevent;
            }
          },
          onPageStarted: (String url) {
            // print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            // print('Page finished loading: $url');
          },
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        ),
        if (widget.myBotConfig.enableCloseButton)
          Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                  icon: Icon(Icons.close),
                  iconSize: 28,
                  onPressed: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  })),
        if (widget.myBotConfig.enableSpeech) SpeechArea()
      ],
    );
  }
}

class SpeechArea extends StatefulWidget {
  const SpeechArea({
    Key key,
  }) : super(key: key);

  @override
  _SpeechAreaState createState() => _SpeechAreaState();
}

class _SpeechAreaState extends State<SpeechArea> {
  // -> controller to control the webview
  SpeechToText stt = SpeechToText();
  bool speechServiceAvailability = false;
  bool listening = false;
  String speechResult;
  String prevRes = "";

  void intializeSpeechService() async {
    if (!speechServiceAvailability) {
      speechServiceAvailability = await stt.initialize(
          onStatus: (status) {
            print('status : $status');
            if (status == "listening") {
              setState(() {
                listening = true;
              });
            } else if (status == "notListening") {
              setState(() {
                listening = false;
              });
              stopRecognitation();
              if (speechResult != null &&
                  speechResult != "" &&
                  prevRes != speechResult) {
                YmBotSdk().sendEvent(data: speechResult);
                prevRes = speechResult;
                speechResult = "";
              }
            }
          },
          onError: (error) {
            print('Speech service error : $error');
          },
          debugLogging: false);
    }
  }

  void stopRecognitation() {
    stt.stop();
  }

  void recogniseSpeech() async {
    if (speechServiceAvailability) {
      speechResult = "";
      stt
          .listen(
        pauseFor: Duration(seconds: 2),
        // listenMode: ListenMode.confirmation,
        listenFor: Duration(seconds: 10),
        onResult: (result) {
          setState(() {
            speechResult = result.recognizedWords;
          });
          print('Speech service result ${result.recognizedWords}');
        },
      )
          .then((value) {
        // print("stopping here");
        // stopRecognitation();
      }).catchError((onError) => debugPrint("An error occured."));
    } else {
      intializeSpeechService();
    }
  }

  @override
  Widget build(BuildContext context) {
    intializeSpeechService();
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          if (listening)
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Colors.white.withOpacity(0.9),
                height: MediaQuery.of(context).size.height / 7,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(speechResult ?? "Ready!"),
                ),
              ),
            ),
          Positioned(
              right: 10,
              bottom: MediaQuery.of(context).size.height / 10,
              child: Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: listening ? Colors.redAccent : Color(0xFF4384f5),
                    borderRadius: BorderRadius.circular(40)),
                child: IconButton(
                    icon: Icon(listening ? Icons.close : Icons.mic),
                    iconSize: 30,
                    color: Colors.white,
                    onPressed: () {
                      print("start speech recoginition");
                      listening ? stopRecognitation() : recogniseSpeech();
                    }),
              )),
        ],
      ),
    );
  }
}

JavascriptChannel _events(BuildContext context, customEventListener) {
  return JavascriptChannel(
    name: 'ReactNativeWebView', // YM channel for catching events from the bot
    onMessageReceived: (JavascriptMessage message) {
      customEventListener(BotEvent.fromJson(jsonDecode(message.message)));
    },
  );
}
