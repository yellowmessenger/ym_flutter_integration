import 'package:flutter/material.dart';
import 'package:ym_flutter_integration/const/constants.dart';

// Configuration model for sending data to the helper functions
class BotConfig {
  String botId;
  bool enableHistory;
  bool enableSpeech;
  bool enableCloseButton;
  String botUrl;
  BuildContext context;

  BotConfig.setConfig({
    @required String botId,
    @required BuildContext context,
    enableHistory,
    enableSpeech,
    enableCloseButton,
  }) {
    this.context = context;
    this.botId = botId;
    this.enableHistory = enableHistory ?? false;
    this.enableSpeech = enableSpeech ?? false;
    this.enableCloseButton = enableCloseButton ?? true;
    this.botUrl =
        "$BASE_URL?botId=${this.botId}&enableHistory=${this.enableHistory.toString()}&ym.payload=";
  }
  BotConfig();
}
