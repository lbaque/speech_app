import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_app/app/api/parametros_api.dart';
import 'package:speech_app/app/modules/splash/splash_controller.dart';
import 'package:speech_app/app/utils/dialogs.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (_) => const Scaffold(
        body: Center(
          child: null,
        ),
      ),
    );
  }
}
