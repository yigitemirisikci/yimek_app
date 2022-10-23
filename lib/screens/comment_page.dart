import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yimek_app_lastversion/service/food_service.dart';
import 'package:yimek_app_lastversion/service/get_user_details.dart';
import '../service/comment_service.dart';

class CommentPage extends StatefulWidget {
  final String mainYemek;
  final String userName;
  final String userUid;
  final String userPictureLink;

  const CommentPage(
      {Key? key,
      required this.mainYemek,
      required this.userName,
      required this.userUid,
      required this.userPictureLink})
      : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController myController = TextEditingController();
  CommentService commentService = CommentService();
  FoodService foodService = FoodService();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "- " + widget.mainYemek + " -",
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
                              color: Colors.grey,
                              blurRadius: 20,
                              spreadRadius: 2)
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
                                    hintText: "Yorum yaz",
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
                                          widget.userUid,
                                          widget.userName,
                                          widget.mainYemek);

                                      foodService.addFood(
                                          widget.mainYemek,
                                          widget.userName,
                                          widget.userUid,
                                          myController.text,
                                          widget.userPictureLink,
                                          "Person/${widget.userUid}");

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
                              stream: foodService.getComments(widget.mainYemek),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                return !snapshot.hasData
                                    ? CircularProgressIndicator(
                                        color: Colors.red,
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          var commentList = snapshot.data.docs;

                                          var hourDif = DateTime.now().hour -
                                              DateTime.parse(commentList[index]
                                                          ["time"]
                                                      .toDate()
                                                      .toString())
                                                  .hour;
                                          var minDif = DateTime.now().minute -
                                              DateTime.parse(commentList[index]
                                                          ["time"]
                                                      .toDate()
                                                      .toString())
                                                  .minute;
                                          return Card(
                                            color: Colors.white,
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      color: Colors
                                                                          .grey,
                                                                      boxShadow: [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .grey,
                                                                        blurRadius:
                                                                            20,
                                                                        spreadRadius:
                                                                            2)
                                                                  ]),
                                                              child: commentList[
                                                                              index]
                                                                          [
                                                                          "userName"] ==
                                                                      "Anonim"
                                                                  ? Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 50,
                                                                    )
                                                                  : GetUserPictureLink(
                                                                      referance:
                                                                          commentList[index]
                                                                              [
                                                                              "person"])),
                                                        ),
                                                        commentList[index][
                                                                    "userName"] ==
                                                                "Anonim"
                                                            ? Text("Anonim: ",style: TextStyle(fontWeight: FontWeight.bold),)
                                                            : GetUserName(
                                                                referance:
                                                                    commentList[
                                                                            index]
                                                                        [
                                                                        "person"]),
                                                        Container(
                                                          width: 120,
                                                          child: Text(commentList[index]
                                                              ["comment"]),
                                                        ),
                                                        new Spacer(),
                                                        Expanded(
                                                          child: hourDif != 0
                                                              ? Text(
                                                              hourDif.toString() +
                                                                  " saat önce")
                                                              : minDif == 0
                                                              ? Text(" az önce")
                                                              : Text(minDif
                                                              .toString() +
                                                              " dakika önce"),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
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
