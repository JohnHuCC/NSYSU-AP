import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nsysu_ap/app.dart';

class ShareDataWidget extends InheritedWidget {
  final MyAppState data;

  ShareDataWidget(this.data, {Widget child}) : super(child: child);

  static ShareDataWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ShareDataWidget);
  }

  @override
  bool updateShouldNotify(ShareDataWidget oldWidget) {
    return true;
  }
}
