import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/fan_profile.dart';

class FirestoreService {
  static final _col =
      FirebaseFirestore.instance.collection('fan_profiles');

  static Stream<List<FanProfile>> profilesStream() => _col
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) =>
          s.docs.map((d) => FanProfile.fromMap(d.id, d.data())).toList());

  static Future<FanProfile?> getProfile(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return FanProfile.fromMap(doc.id, doc.data()!);
  }

  static Future<String> createProfile(FanProfile profile) async {
    final ref = await _col.add(profile.toMap());
    return ref.id;
  }

  static Future<void> updateProfile(
          String id, Map<String, dynamic> data) =>
      _col.doc(id).update(data);

  /// Upload raw bytes to Firebase Storage, return the download URL.
  static Future<String> uploadBytes({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final ref = FirebaseStorage.instance.ref(path);
    final task = await ref.putData(
        bytes, SettableMetadata(contentType: contentType));
    return task.ref.getDownloadURL();
  }
}
