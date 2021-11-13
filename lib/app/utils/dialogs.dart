import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_app/app/utils/constant.dart';

abstract class ProgressDialog {
  static show(BuildContext context, String title) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return WillPopScope(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white.withOpacity(0.9),
                child: Stack(
                  children: [
                    Center(
                        child: Text(title,style: TextStyle( fontSize: 10, color: primaryTextColor),),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                ),
              ),
              onWillPop: () async => false);
        });
  }

  static dissmiss(BuildContext context) {
    Navigator.pop(context);
  }
}

