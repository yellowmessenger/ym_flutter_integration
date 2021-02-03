import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ym_flutter_integration/models/BotConfig.dart';
import 'package:ym_flutter_integration/models/BotPayload.dart';
import 'package:ym_flutter_integration/ym_flutter_integration.dart';

import 'models/botEvents.dart';

class BotViewWidget extends StatefulWidget {
  // To remember bot config
  final BotConfig myBotConfig;
  // For lifting up the web controller form the web view and listening to the post events from the chatbot
  final Function setWebController, customEventListener;
  // To work with payload add, clear, update
  final BotPayload myBotPayload;
  //constructor for taking the intial config from the client
  BotViewWidget(
      {this.myBotConfig,
      this.setWebController,
      @required this.myBotPayload,
      @required this.customEventListener});
  @override
  _BotViewWidgetState createState() => _BotViewWidgetState();
}

class _BotViewWidgetState extends State<BotViewWidget> {
  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    // Creating bot url to request for the chatbot
    String botUrl =
        '${widget.myBotConfig.botUrl}${widget.myBotPayload.getBotPayload()}';
    return Stack(
      children: <Widget>[
        // return the chatbot from the webview
        WebView(
          // sending the chatbot url
          initialUrl: botUrl,
          // enabling the javascript for the webside interations
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
            // Handling navigation inside of chatbot and outside for third party links
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
          // Button to close the chatbot
          Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                  icon: Icon(Icons.close),
                  iconSize: 28,
                  onPressed: () {
                    // Closing bot if there is a widget to go back
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  })),
        if (widget.myBotConfig.enableSpeech) SpeechArea()
      ],
    );
  }
}

// widget to show the FAD to interact with the client speech
class SpeechArea extends StatefulWidget {
  // handling user speech with the chatbot using mike button
  const SpeechArea({
    Key key,
  }) : super(key: key);

  @override
  _SpeechAreaState createState() => _SpeechAreaState();
}

class _SpeechAreaState extends State<SpeechArea> {
  // -> controller to control the webview
  SpeechToText stt = SpeechToText();
  // To check if the service available to listen
  bool speechServiceAvailability = false;
  // To check if bot is listening to user voice
  bool listening = false;
  // final result to send to chatbot
  String speechResult;
  String prevRes = "";

  // initialise in order interact and start listening to the clients voice
  void intializeSpeechService() async {
    if (!speechServiceAvailability) {
      // initialising the speech service
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
                YmFlutterIntegration().sendEvent(data: speechResult);
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

  // Stopping the speech recognising
  void stopRecognitation() {
    stt.stop();
  }

  // Recognise the client speech
  void recogniseSpeech() async {
    // Starting to listing the clients voice
    if (speechServiceAvailability) {
      // capturing speech service
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

//listen to the bot events
JavascriptChannel _events(BuildContext context, customEventListener) {
  return JavascriptChannel(
    name: 'ReactNativeWebView', // YM channel for catching events from the bot
    onMessageReceived: (JavascriptMessage message) {
      customEventListener(BotEvent.fromJson(jsonDecode(message.message)));
    },
  );
}
