import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yimek_app_lastversion/models/Yemek.dart';
import 'package:yimek_app_lastversion/screens/home_page.dart';

import '../service/comment_service.dart';

class CommentPage extends StatefulWidget {
  final Yemek mainYemek;

  const CommentPage({Key? key, required this.mainYemek}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController myController = TextEditingController();
  late String _userName;
  late String _userUid;
  CommentService commentService = CommentService();

  fetch() async {
    final _firebaseUser = await FirebaseAuth.instance.currentUser;

    if (_firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('Person')
          .doc(_firebaseUser.uid)
          .get()
          .then((value) {
        _userName = value.data()!["userName"];
        _userUid = _firebaseUser.uid;
      });
    }
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "- " + widget.mainYemek.name + " -",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25, right: 20, left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey, blurRadius: 20, spreadRadius: 2)
                        ]),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 12, right: 12, top: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  cursorColor: Colors.white,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic),
                                  controller: myController,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.comment,
                                      color: Colors.white,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.white),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.white)),
                                    hintText: "Enter a comment",
                                    hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      minimumSize: Size(20, 50)),
                                  onPressed: () {
                                    setState(() {
                                      commentService.addComment(
                                          myController.text,
                                          _userUid,
                                          _userName,
                                          widget.mainYemek.name);
                                      myController.clear();
                                    });
                                  },
                                  child: Icon(Icons.send, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: StreamBuilder(
                              stream: commentService.getComments(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                var commentList = snapshot.data.docs;

                                var mainYemekYorumlari = [];

                                for (var ele in commentList) {
                                  if (ele["yemekAdi"] ==
                                      widget.mainYemek.name) {
                                    mainYemekYorumlari.add(ele);
                                  }
                                }

                                return !snapshot.hasData
                                    ? CircularProgressIndicator(
                                        color: Colors.red,
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: mainYemekYorumlari.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: Colors.white,
                                            child: Container(
                                              height: 30,
                                              child: Text(
                                                  mainYemekYorumlari[index]
                                                          ["userName"] +
                                                      ": " +
                                                      mainYemekYorumlari[index]
                                                          ["comment"]),
                                            ),
                                          );
                                        });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
