import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ym_flutter_integration/ym_flutter_integration.dart';

void main() {
  const MethodChannel channel = MethodChannel('ym_flutter_integration');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
