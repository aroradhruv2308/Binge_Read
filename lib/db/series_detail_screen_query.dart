import 'package:binge_read/db/appDto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

        Episode episodeDetail = Episode(
          name: episodeName ?? '', // Assign an empty string if episodeName is null
          number: episodeNumber ?? 0, // Assign 0 if episodeNumber is null
          summary: episodeSummary ?? '', // Assign an empty string if episodeSummary is null
        );
        listOfEpisodes.add(episodeDetail);
        // Do something with the episode data
      }

      return listOfEpisodes;
    }
  }
  return [];
}
