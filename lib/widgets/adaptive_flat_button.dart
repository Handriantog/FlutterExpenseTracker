import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String buttonText;
  final Function onClickHandler;

  AdaptiveFlatButton(this.buttonText, this.onClickHandler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              buttonText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: onClickHandler)
        : TextButton(
            child: Text(
              buttonText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: onClickHandler,
          );
  }
}
