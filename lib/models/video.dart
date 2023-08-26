import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String id;
  List likes;

  String description;
  String videoUrl;
  String thumbnail;

  Video({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.description,
    required this.videoUrl,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "id": id,
        "likes": likes,
        "description": description,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      likes: snapshot['likes'],
      description: snapshot['dexcription'],
      videoUrl: snapshot['videoUrl'],
      thumbnail: snapshot['thumbnail'],
    );
  }
}
