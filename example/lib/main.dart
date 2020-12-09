import 'package:flutter/material.dart';
import 'package:ym_flutter_integration/models/botEvents.dart';
import 'package:ym_flutter_integration/ym_flutter_integration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: BotPage(),
        ));
  }
}

class BotPage extends StatefulWidget {
  static String routeName = "/BotPage";
  @override
  _BotPageState createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  YmFlutterIntegration ymFlutterIntegration;
  String botId = "x1597301712805";

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
    ymFlutterIntegration.addPayload(key: "Name", value: "Purush");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
            child: ymFlutterIntegration.getBotWidget(
              botEventListener: (BotEvent botEvent) {
                switch (botEvent.code) {
                  case "choosen_other_option":
                    // ymFlutterIntegration.closeBot();
                    // ymFlutterIntegration.addPayload(key: "Name", value: "Purush");
                    // ymFlutterIntegration.updatePayload();
                    print("code is ${botEvent.code}, data is ${botEvent.data}");
                    break;
                  default:
                    print("No data");
                }
              },
            ),
          ),
        ],
      )),
    );
  }
}
