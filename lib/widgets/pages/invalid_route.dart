import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class InvalidRoutePage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String? title;
  final String? message;

  InvalidRoutePage({
    Key? key,
    this.title,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: LunaAppBar(
        title: title ?? 'LunaSea',
        scrollControllers: const [],
      ),
      body: LunaMessage.goBack(
        context: context,
        text: message ?? '404: Not Found',
      ),
    );
  }
}
