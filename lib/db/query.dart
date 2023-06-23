import 'package:binge_read/Utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateViewCountsInFirestore() async {
  try {
    final batch = FirebaseFirestore.instance.batch();

    for (final seriesId in Globals.seriesReadCount.keys) {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Series').where('series_id', isEqualTo: seriesId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final seriesDoc = querySnapshot.docs.first;
        final seriesRef = FirebaseFirestore.instance.collection('Series').doc(seriesDoc.id);

        batch.update(seriesRef, {
          'total_views': FieldValue.increment(Globals.seriesReadCount[seriesId] as num),
        });
      }
    }

    await batch.commit();
    Globals.seriesReadCount.clear();
  } catch (error) {
    // Handle the error accordingly (e.g., display an error message to the user)
    print('Failed to update view counts: $error');
  }
}
