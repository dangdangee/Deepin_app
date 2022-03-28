import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 우리가 가입을 다 해줌 실험단계에서.
// User3 - 유저별 현재 클릭 현황 // 유저리스트 - profile image

// Just write
Future<void> writeUser(String displayName) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  await users.doc(displayName).set({'display':displayName});
}

Future<void> writeRoomUserDisplayRole(String displayName, String role) async {
  CollectionReference users = FirebaseFirestore.instance.collection('rooms').doc('0').collection('users');
  await users.doc(displayName).set({'role':role});
}

Future<void> writeRoomUserTouch(String displayName, String touch_name) async {
  CollectionReference users = FirebaseFirestore.instance.collection('rooms').doc('0').collection('users');
  await users.doc(displayName).update({'touch':touch_name});
}

Future<void> writeSharerTopic(String topic_name) async {
  CollectionReference users = FirebaseFirestore.instance.collection('rooms').doc('0').collection('users');
  String? sharer;
  sharer = await readSharerUser();
  if (sharer == FirebaseAuth.instance.currentUser!.displayName) {
    await users.doc(sharer).update({'topic': topic_name});
  }
}

Future<void> eraseRoomUserTouch(String displayName) async {
  CollectionReference users = FirebaseFirestore.instance.collection('rooms').doc('0').collection('users');
  await users.doc(displayName).update({'touch': FieldValue.delete()});
}

Future<bool> readRoomUser(String displayName) async {
  CollectionReference users = FirebaseFirestore.instance.collection('rooms').doc('0').collection('users');
  DocumentSnapshot documentSnapshot = await users.doc(displayName).get();
  return documentSnapshot.exists;
}

Future<String> readRoomUserRole(String displayName) async {
  CollectionReference users = FirebaseFirestore.instance.collection('rooms').doc('0').collection('users');
  DocumentSnapshot documentSnapshot = await users.doc(displayName).get();
  final Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
  return data['role'];
}

Future<List<String>> readViewerUsers() async {
  final List<String> viewers = [];
  CollectionReference users = FirebaseFirestore.instance.collection('rooms').doc('0').collection('users');
  QuerySnapshot querySnapshot = await users.get();
  querySnapshot.docs.forEach((doc) {
    final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    if (data['role'] == 'Viewer') {
      viewers.add(doc.id);
    };
  });
  assert(viewers.length < 3 || (throw Exception("# of Viewers should be less than 3")));
  return viewers;
}

Future<String> readSharerUser() async {
  final List<String> sharer = [];
  CollectionReference users = FirebaseFirestore.instance.collection('rooms').doc('0').collection('users');
  QuerySnapshot querySnapshot = await users.get();
  querySnapshot.docs.forEach((doc) {
    final Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    if (data['role'] == 'Sharer') {
      sharer.add(doc.id);
    };
  });
  assert(sharer.length == 1 || (throw Exception("# of Sharer should be 1")));
  return sharer[0];
}

