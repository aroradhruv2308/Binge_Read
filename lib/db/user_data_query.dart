import 'package:binge_read/Utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addNewUser(Map<String, dynamic> data) async {
  final String email = data['email'];
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('User-Data').where('email', isEqualTo: email).limit(1).get();

  if (snapshot.docs.isNotEmpty) {
    return;
  }

  try {
    await FirebaseFirestore.instance.collection('User-Data').add(data);
    print('New user added successfully!');
  } catch (error) {
    print('Error adding new user: $error');
  }
}

Future<DocumentSnapshot?> getUserByEmail(String email) async {
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('User-Data').where('email', isEqualTo: email).limit(1).get();
  if (snapshot.docs.isNotEmpty) {
    return snapshot.docs.first;
  }

  return null;
}
