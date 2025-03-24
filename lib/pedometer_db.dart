// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:io';

import 'package:pedometer/pedometer.dart';
import 'package:pedometer_db/provider/step_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/services.dart';

import 'model/step.dart';
import 'pedometer_db_method_channel.dart';

class PedometerDb {
  final _channelPedometerDb = MethodChannelPedometerDb();
  final _stepProvider = StepProvider();


  Future<void> initialize() async {
    await _stepProvider.initDatabase();
    // await _stepProvider.initStepCountStream();
  }

  Future<int> queryPedometerData(int startTime, int endTime) async {
    // print("queryPedometerData : $stepProvider, $_channelPedometerDb");
    if(Platform.isIOS) {
      return await _channelPedometerDb.queryPedometerDataFromOS(startTime, endTime) ?? 0;
    }
    return await _stepProvider.queryPedometerData(startTime, endTime);
  }

  Future<int> insertPedometerData(StepCount event) async {
    return await _stepProvider.insertData(event) ?? 0;
  }

  Future<void> insertStepData({
    required DateTime timeStamp
  }) async {

    Step? step = await _stepProvider.getLastStep();
    print("dnjlkfadslkfsaf");
    print(step?.total ?? 0);
    print(step?.last ?? 0);

    await _stepProvider.db?.insert(
      tableName, // table name
      {
        'total': (step?.total ?? 0)+1,
        'last': (step?.last ?? 0)+1,
        'timestamp': timeStamp.millisecondsSinceEpoch,
        'plus': 1,
      }, // new post row data
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
