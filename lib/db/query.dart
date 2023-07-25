// ignore_for_file: unused_import

import 'dart:math';

import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/models/user.dart';
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
  // Get to the particular series
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Series').where('series_id', isEqualTo: seriesId).limit(1).get();
  if (querySnapshot.docs.isNotEmpty) {
    // Get to the particular season
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
        // TODO1: Get episodeId as well (episode id will be unique, it will be a
        // combination of series, season and episode.)
        // String? episodeId = episodeData?['episode_id'] as String?

        // TODO2: Once you get the episodeId then you already have userdata,
        // which you fetched while starting the app. Get percentage read for
        // this episode from userdata. (First check how user data format will
        // look like.)

        // TODO3: Add pctRead in Episode class.

        Episode episodeDetail = Episode(
            name: episodeName ?? '',
            number: episodeNumber ?? 0,
            summary: episodeSummary ?? '',
            htmlUrl: episodeUrl ?? "Html default Url");
        listOfEpisodes.add(episodeDetail);
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

Future<String> addUser(Map<String, dynamic> data) async {
  final String email = data['email'];
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('User-Data').where('email', isEqualTo: email).limit(1).get();

  if (snapshot.docs.isNotEmpty) {
    DocumentSnapshot firstDocument = snapshot.docs.first;
    var profilePhoto = firstDocument['photo-url'];
    return profilePhoto;
  }

  // This will get executed user object was not present in firestore
  try {
    String imageUrl = "";
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('App-Data').get();
    dynamic documents = snapshot.docs;

    if (documents.length > 0) {
      var firstDocument = documents[0] as QueryDocumentSnapshot<Object?>;
      var appData = firstDocument.data() as Map<String, dynamic>?;
      if (appData != null) {
        Map<String, dynamic> profilePictures = appData['profile_pictures'];
        Random random = Random();
        int randomIndex = random.nextInt(profilePictures.length);
        String randomKey = profilePictures.keys.elementAt(randomIndex);
        String? randomImage = profilePictures[randomKey];
        imageUrl = randomImage ?? "";
        data["photo-url"] = randomImage;
      }
    }
    await FirebaseFirestore.instance.collection('User-Data').add(data);
    print('New user added successfully!');
    return imageUrl;
  } catch (error) {
    print('Error adding new user: $error');
    return "";
  }
}

Future<Map<String, dynamic>?> getUserData(String email) async {
  // User data should look like below:
  // {
  //   "email": EMAIL,
  //   "name": NAME,
  //   "photo-url": PHOTO-URL,
  //   "app_data": {
  //      "episodes":{
  //          "S3SN1EP1":{
  //              "pct_read": 80,
  //            },
  //          "S3SN1EP2": {
  //              "pct_read": 30
  //            },
  //        }
  //    }
  // }

  // Create empty map to store user data in above format.
  Map<String, dynamic> userData = {};

  // Get email, name and photo-url from User-Data collection.
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('User-Data').where('email', isEqualTo: email).limit(1).get();

  if (snapshot.docs.isNotEmpty) {
    userData = snapshot.docs.first.data() as Map<String, dynamic>;

    // Get subcollection app-data content as well, this will contain
    // episodes related data as per user usage of app.
    final appDataCollection = snapshot.docs.first.reference.collection('app_data');

    // app_data collection only have one document which contains all the episode
    // related meta-data.
    final episodeDataSnapshot = await appDataCollection.limit(1).get();

    if (episodeDataSnapshot.docs.isNotEmpty) {
      final episodeData = episodeDataSnapshot.docs.first.data();
      userData = {...userData, ...episodeData};
    }

    return userData;
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
