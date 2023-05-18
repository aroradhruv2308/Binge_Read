import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getALLSeries() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Series').get();

  dynamic documents = querySnapshot.docs;
  return documents;
}
