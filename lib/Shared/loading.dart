import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget loading() {
  return Center(
      child: Container(
    height: 60,
    width: 80,
    child: LoadingIndicator(
      indicatorType: Indicator.lineScaleParty,
      colors: Colors.primaries,
    ),
  ));
}
