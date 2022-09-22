import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  String id;
  String comment;
  String userId;
  String yemekAdi;

  Comment({required this.id,required this.comment,required this.userId, required this.yemekAdi});

  factory Comment.fromSnaphot(DocumentSnapshot documentSnapshot){
    return Comment(id: documentSnapshot.id,comment: documentSnapshot["comment"], userId: documentSnapshot["userId"], yemekAdi: documentSnapshot["yemekAdi"]);
  }
}