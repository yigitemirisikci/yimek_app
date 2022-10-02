import 'package:flutter/material.dart';
import 'package:yimek_app_lastversion/service/food_service.dart';
import '../service/comment_service.dart';

class CommentPage extends StatefulWidget {
  final String mainYemek;
  final String userName;
  final String userUid;

  const CommentPage(
      {Key? key,
      required this.mainYemek,
      required this.userName,
      required this.userUid})
      : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController myController = TextEditingController();
  CommentService commentService = CommentService();
  FoodService foodService = FoodService();

  @override
  void initState() {
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
                                          widget.userUid,
                                          widget.userName,
                                          widget.mainYemek);

                                      foodService.addFood(
                                          widget.mainYemek,
                                          widget.userName,
                                          widget.userUid,
                                          myController.text);

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

                                          return Card(
                                            color: Colors.white,
                                            child: Container(
                                              height: 30,
                                              child: Text(
                                                  commentList[index]["userName"] +
                                                      ": " +
                                                      commentList[index]["comment"]),
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
