import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllGenere() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('App-Data').get();

  dynamic documents = querySnapshot.docs;
  return documents;
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getBooksForAGenre() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Series').get();

  dynamic documents = querySnapshot.docs;
  return documents;
}
