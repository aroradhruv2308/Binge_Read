// ignore_for_file: unused_import

import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllSeries() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Series').get();

  dynamic documents = querySnapshot.docs;
  return documents;
}

Future<List<Episode>> fetchEpisodes({required int seasonId, required int seriesId}) async {
  // get to the particular series
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Series').where('series_id', isEqualTo: seriesId).limit(1).get();
  if (querySnapshot.docs.isNotEmpty) {
    //get to the particular season
    DocumentSnapshot seriesDocument = querySnapshot.docs[0];
    CollectionReference seasonsCollection = seriesDocument.reference.collection('seasons');

    QuerySnapshot seasonQuerySnapshot = await seasonsCollection.where('season_id', isEqualTo: seasonId).limit(1).get();

    if (seasonQuerySnapshot.docs.isNotEmpty) {
      DocumentSnapshot seasonDocument = seasonQuerySnapshot.docs[0];

      CollectionReference episodesCollection = seasonDocument.reference.collection('episodes');
      QuerySnapshot episodesQuerySnapshot = await episodesCollection.get();

      List<DocumentSnapshot> episodeDocuments = episodesQuerySnapshot.docs;
      List<Episode> listOfEpisodes = [];
      for (DocumentSnapshot episodeDocument in episodeDocuments) {
        Map<String, dynamic>? episodeData = episodeDocument.data() as Map<String, dynamic>?;

        String? episodeName = episodeData?['episode_name'] as String?;
        int? episodeNumber = episodeData?['number'] as int?;
        String? episodeSummary = episodeData?['episode_summary'] as String?;
        String? episodeUrl = episodeData?['episode_link'] as String?;

        Episode episodeDetail = Episode(
            name: episodeName ?? '', // Assign an empty string if episodeName is null
            number: episodeNumber ?? 0, // Assign 0 if episodeNumber is null
            summary: episodeSummary ?? '',
            htmlUrl: episodeUrl ?? "Html default Url" // Assign an empty string if episodeSummary is null
            );
        listOfEpisodes.add(episodeDetail);
        // Do something with the episode data
      }

      return listOfEpisodes;
    }
  }
  return [];
}

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

Future<void> updateUserNameByEmail(String email, String newName) async {
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('User-Data').where('email', isEqualTo: email).limit(1).get();

  if (snapshot.docs.isNotEmpty) {
    final DocumentSnapshot userDocument = snapshot.docs.first;
    final String documentId = userDocument.id;

    await FirebaseFirestore.instance.collection('User-Data').doc(documentId).update({'name': newName});
  }
}

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

Future<Map<String, dynamic>?> fetchSeriesDataById(int seriesId) async {
  CollectionReference seriesCollection = FirebaseFirestore.instance.collection('Series');

  try {
    QuerySnapshot seriesQuery = await seriesCollection.where("series_id", isEqualTo: seriesId).limit(1).get();
    if (seriesQuery.size > 0) {
      DocumentSnapshot seriesSnapshot = seriesQuery.docs[0];
      return seriesSnapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  } catch (error) {
    print('Error fetching series data: $error');
    return null;
  }
}

Future<List<dynamic>> fetchIDsFromFirestore(String typeOfId) async {
  CollectionReference userCollection = FirebaseFirestore.instance.collection('User-Data');
  try {
    if (Globals.userEmail != "") {
      QuerySnapshot userDataQuery = await userCollection.where("email", isEqualTo: Globals.userEmail).limit(1).get();
      if (userDataQuery.size > 0) {
        DocumentSnapshot userDataSnapshot = userDataQuery.docs[0];
        Map<String, dynamic> userDataMap = userDataSnapshot.data() as Map<String, dynamic>;
        return userDataMap[typeOfId];
      } else {
        return [];
      }
    }
    return [];
  } catch (error) {
    print('Error fetching series data: $error');
    return [];
  }
}
