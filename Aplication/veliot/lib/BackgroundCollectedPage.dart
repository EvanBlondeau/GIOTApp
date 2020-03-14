import 'package:flutter/material.dart';

import './BackgroundCollectingTask.dart';
import './helper/LineChart.dart';
import './helper/PaintStyle.dart';

class BackgroundCollectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BackgroundCollectingTask task = BackgroundCollectingTask.of(context, rebuildOnChange: true);

    return Scaffold(
        appBar: AppBar(
          title: Text('Collected data')
        ),
        body: Center(child: Text('Hello World')
          ),
    );
  }
}