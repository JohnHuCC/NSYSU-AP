import 'package:flutter/material.dart';
import 'package:nsysu_ap/res/resource.dart' as Resource;

class DialogOption extends StatelessWidget {
  final String text;
  final bool check;
  final Function onPressed;

  const DialogOption(
      {Key key,
      @required this.text,
      @required this.check,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 16.0,
                    color: check ? Resource.Colors.blueAccent : null),
              ),
            ),
            if (check)
              Icon(
                Icons.check,
                color: Resource.Colors.blueAccent,
              )
          ],
        ),
        onPressed: onPressed);
  }
}
