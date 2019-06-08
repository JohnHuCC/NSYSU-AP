import 'package:flutter/material.dart';
import 'package:nsysu_ap/res/resource.dart' as Resource;

class DefaultDialog extends StatelessWidget {
  final String title;
  final Widget contentWidget;
  final String actionText;
  final Function actionFunction;

  const DefaultDialog(
      {Key key,
      this.title,
      this.contentWidget,
      this.actionText,
      @required this.actionFunction})
      : super(key: key);

  static showSample(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext context) => DefaultDialog(
              title: '預約成功',
              actionText: '我知道了',
              actionFunction: () =>
                  Navigator.of(context, rootNavigator: true).pop('dialog'),
              contentWidget: Text(
                '預約日期：2017/09/05\n上車地點：燕巢校區\n預約班次：08:20',
                style: TextStyle(color: Resource.Colors.grey, height: 1.3),
              ),
            ),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Resource.Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      titlePadding: EdgeInsets.symmetric(vertical: 16.0),
      contentPadding: EdgeInsets.all(0.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
                bottom: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
            child: contentWidget,
          ),
          Container(
            width: double.infinity,
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  actionText,
                  style: TextStyle(
                    color: Resource.Colors.grey,
                    fontSize: 18.0,
                  ),
                ),
              ),
              onTap: actionFunction,
            ),
          ),
        ],
      ),
    );
  }
}
