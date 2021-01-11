import 'package:flutter/material.dart';
import 'package:ym_flutter_integration/models/botEvents.dart';
import 'package:ym_flutter_integration/ym_flutter_integration.dart';

void main() {
  // Starting the app
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Using material app for added functionality
    return MaterialApp(
        // for removing the debug banner on the top right
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // Calling th widget to render the bot
          body: BotPage(),
        ));
  }
}

class BotPage extends StatefulWidget {
  // Creating a static route
  static String routeName = "/BotPage";
  @override
  _BotPageState createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  // Initialising a global object on which the bot widget is called back
  YmFlutterIntegration ymFlutterIntegration;
  // Dummy bot id not to be used
  String botId = "x1597301712805";

  @override
  void initState() {
    super.initState();

    // Declaring the Object with the instance
    ymFlutterIntegration = YmFlutterIntegration();

    // Setting the config to get the bot widget
    ymFlutterIntegration.setConfig(
        context: context, // Sending present page context for more functionality
        botId:
            botId, // sending bot id that needs to be rendered on to the widget
        enableHistory: false, // Disable previous history
        enableSpeech: false, // Disabled mike
        enableCloseButton: true);

    // Adding payload for the bot for initialisation
    ymFlutterIntegration.addPayload(key: "Name", value: "Purush");
  }

  @override
  Widget build(BuildContext context) {
    // using safe area to save UI/UX from the notches
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          // Expanded widget to take as much as space for bot view widget
          Expanded(
            // Calling the bot widget on the object where configuration is set
            child: ymFlutterIntegration.getBotWidget(
              // Sending a call back function for the bot event listener
              botEventListener: (BotEvent botEvent) {
                // Listening to BotEvent model for code and data part
                switch (botEvent.code) {
                  // identifying the event by its codes
                  case "choosen_other_option":
                    // ymFlutterIntegration.closeBot();
                    // ymFlutterIntegration.addPayload(key: "Name", value: "Purush");
                    // ymFlutterIntegration.updatePayload();
                    print("code is ${botEvent.code}, data is ${botEvent.data}");
                    break;
                  //Default fallback when no event is found
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
