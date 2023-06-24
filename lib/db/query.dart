// ignore_for_file: unused_import

import 'package:binge_read/Utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> updateViewCountsInFirestore() async {
  const String serverEndpoint = 'http://192.168.1.37:3000/api/series/update-view-counts';

  try {
    final response = await http.post(
      Uri.parse(serverEndpoint),
      body: jsonEncode(Globals.seriesReadCount),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Request was successful
      print('View counts updated successfully');
    } else {
      // Request failed
      print('Failed to update view counts');
    }
  } catch (e) {
    // Exception occurred
    print('Error updating view counts: $e');
  }
}

void _updateFirestoreViewCounts(dynamic batch) {
  for (final seriesId in Globals.seriesReadCount.keys) {
    final querySnapshot = FirebaseFirestore.instance.collection('Series').where('series_id', isEqualTo: seriesId).get();

    querySnapshot.then((QuerySnapshot snapshot) {
      final docs = snapshot.docs;
      if (docs.isNotEmpty) {
        final seriesDoc = docs[0]; // Access the first document using [0]
        final seriesRef = FirebaseFirestore.instance.collection('Series').doc(seriesDoc.id);

        batch.update(seriesRef, {
          'total_views': FieldValue.increment(Globals.seriesReadCount[seriesId] as num),
        });
      }
    });
  }

  batch.commit();
}
