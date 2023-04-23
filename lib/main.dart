import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Cross'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('samples.flutter.dev/payment');

  // Get battery level.
  String _payResult = 'Click To Pay.';

  Future<void> _paymentResult() async {
    String payResult;
    try {
      final int result = await platform.invokeMethod('getPayResult', [123]);
      payResult = 'Pay success: $result';
    } on PlatformException catch (e) {
      payResult = "Pay fail: '${e.message}'.";
    }

    setState(() {
      _payResult = payResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            child: Text(_payResult),
            onPressed: () {
              _paymentResult();
            },
          ),
          Text(_payResult),
        ],
      )),
    );
  }
}
