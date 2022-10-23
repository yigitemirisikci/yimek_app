import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yimek_app_lastversion/models/Comment.dart';

class CommentService{
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  addComment(String comment, String userId,String userName ,String yemekAdi) async{
    var collection = firebaseFirestore.collection("Comments");

    var documentRef = await collection.add({
      'comment': comment,
      'userId': userId,
      'userName' : userName,
      'yemekAdi' : yemekAdi
    });
    
    return Comment(id: documentRef.id,comment: comment, userId: userId, yemekAdi: yemekAdi, userName: userName);
  }

  Stream<QuerySnapshot> getComments() {
    var collection = firebaseFirestore.collection("Comments").snapshots();

    return collection;
  }

  Future<String> getPictureLink(String uid) async{
    String url = "";
    await firebaseFirestore.collection("Person").doc(uid).get().then((value) {
      url = value.data()!["pictureLink"];
    });
    return url;
  }
}