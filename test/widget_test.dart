import 'package:fademasterz/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';

const _onePxTransparentPng = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});

    // Provide a 1x1 PNG for any Image.asset used during tests.
    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        final key = utf8.decode(message!.buffer.asUint8List());
        if (key == 'AssetManifest.bin') {
          return const StandardMessageCodec()
              .encodeMessage(<String, dynamic>{});
        }
        if (key == 'AssetManifest.json' || key == 'FontManifest.json') {
          return ByteData.view(Uint8List.fromList(utf8.encode('{}')).buffer);
        }
        return ByteData.view(Uint8List.fromList(_onePxTransparentPng).buffer);
      },
    );
  });

  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Allow any zero-duration timers (e.g. Upgrader init) to complete.
    await tester.pump(const Duration(milliseconds: 1));

    // Splash screen schedules a delayed navigation after 3 seconds.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
