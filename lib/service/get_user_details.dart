import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserName extends StatelessWidget {
  final String referance;

  const GetUserName({Key? key, required this.referance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return FutureBuilder<DocumentSnapshot>(
      future: firebaseFirestore.doc(referance).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            data["userName"] + ": ",
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        }
        return Text("...");
      }),
    );
  }
}

class GetUserPictureLink extends StatelessWidget {
  final String referance;

  const GetUserPictureLink({Key? key, required this.referance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return FutureBuilder<DocumentSnapshot>(
      future: firebaseFirestore.doc(referance).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          return Image(
            image: NetworkImage(
                data["pictureLink"]),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          );
        }
        return Icon(
          Icons
              .person,
          color: Colors
              .white,
          size: 50,
        );
      }),
    );
  }
}

