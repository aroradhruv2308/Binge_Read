import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addNewUser(Map<String, dynamic> data) async {
  try {
    await FirebaseFirestore.instance.collection('User-Data').add(data);
    print('New user added successfully!');
  } catch (error) {
    print('Error adding new user: $error');
  }
}
