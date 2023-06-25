import 'dart:async';

import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserAppDataService {
  late Box<AppData> _userAppData;
  bool _isTimerRunning = false;
  // ignore: unused_field
  Timer? _updateTimer;

  void startTimer() {
    _updateTimer = Timer(const Duration(seconds: 10), () {
      if (_isTimerRunning) {
        _isTimerRunning = false;
        batchUpdateReadCounts();
      }
    });
    _isTimerRunning = true;
  }

  Future<void> batchUpdateReadCounts() async {
    logger.e("updating count");
    final appData = _userAppData.get('appData');
    if (appData != null) {
      final readCountUpdates = appData.seriesReadCount;
      if (readCountUpdates.isNotEmpty) {
        final batch = FirebaseFirestore.instance.batch();

        for (final seriesId in readCountUpdates.keys) {
          final querySnapshot = await FirebaseFirestore.instance
              .collection('Series')
              .where('series_id', isEqualTo: int.parse(seriesId))
              .get();

          final docs = querySnapshot.docs;
          if (docs.isNotEmpty) {
            final seriesDoc = docs[0];
            final seriesRef = FirebaseFirestore.instance.collection('Series').doc(seriesDoc.id);

            batch.update(
              seriesRef,
              {
                'total_views': FieldValue.increment(readCountUpdates[seriesId] as int),
              },
            );
          }
        }

        await batch.commit();

        appData.seriesReadCount.clear();
        await _userAppData.put('appData', appData);
      }
    }
  }

  Future<void> init() async {
    _userAppData = await Hive.openBox<AppData>('userAppData');
  }

  Future<void> incrementReadCount(String seriesId) async {
    final appData = _userAppData.get('appData');
    if (appData != null) {
      appData.seriesReadCount.update(seriesId, (value) => value + 1, ifAbsent: () => 1);
      await _userAppData.put('appData', appData);

      if (!_isTimerRunning) {
        startTimer();
      }
    } else {
      // Initialize appData with an empty series and read count map
      final newAppData = AppData({seriesId: 1});
      await _userAppData.put('appData', newAppData);
    }
  }

  Future<void> dispose() async {
    await _userAppData.close();
  }
}
