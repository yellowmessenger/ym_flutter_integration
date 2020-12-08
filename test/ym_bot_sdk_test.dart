import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ym_bot_sdk/ym_bot_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('ym_bot_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await YmBotSdk.platformVersion, '42');
  });
}
