// TODO: FIREBASE
// import 'dart:typed_data';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// final FirebaseStorage _storage = FirebaseStorage.instance;
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// mixin instance {}

// class FirebaseFireStore {}

// class StoreData {
//   Future<String> uploadImageToStorage(String childName, Uint8List file) async {
//     Reference ref = _storage.ref().child(childName);
//     UploadTask uploadTask = ref.putData(file);
//     TaskSnapshot taskSnapshot = await uploadTask;
//     String url = await taskSnapshot.ref.getDownloadURL();
//     return url;
//   }

//   Future<String> saveData({
//     required String collection,
//     required Uint8List file,
//   }) async {
//     try {
//       String imageUrl = await uploadImageToStorage('images/$collection', file);
//       await _firestore.collection(collection).add({'image': imageUrl});
//       return Future.value('success');
//     } catch (e) {}
//     return Future.value('error');
//   }
// }
