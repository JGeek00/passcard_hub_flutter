import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:buswallet/providers/app_config_provider.dart';


Color getColorForNavBar(BuildContext context) {
  final configProvider = Provider.of<AppConfigProvider>(context);

  if (configProvider.modalBottomSheetOpen == true) {
    return Theme.of(context).backgroundColor;
  }
  else {
    return Theme.of(context).scaffoldBackgroundColor;
  }
}