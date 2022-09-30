import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:yimek_app_lastversion/service/comment_service.dart';
import '../models/Yemek.dart';
import 'comment_page.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var data;
  var url = Uri.parse(
      "http://www.sksdb.hacettepe.edu.tr/bidbnew/grid.php?parameters=qbapuL6kmaScnHaup8DEm1B8maqturW8haidnI%2Bsq8F%2FgY1fiZWdnKShq8bTlaOZXq%2BmwWjLzJyPlpmcpbm1kNORopmYXI22tLzHXKmVnZykwafFhImVnZWipbq0f8qRnJ%2BioF6go7%2FOoplWqKSltLa805yVj5agnsGmkNORopmYXam2qbi%2Bo5mqlXRrinJdf1BQUFBXWXVMc39QUA%3D%3D");
  List<Yemek> yemekler = [];

  late Yemek mainYemek;
  final myController = TextEditingController();
  bool comment = true;
  bool isLoaded = false;

  late String _userName;
  late String _userUid;
  CommentService commentService = CommentService();

  String changeTrLetters(String st) {
    st = st.replaceAll(RegExp('Ä±'), 'i');
    st = st.replaceAll(RegExp('Ã'), 'C');
    st = st.replaceAll(RegExp('Ã¼'), 'u');
    st = st.replaceAll(RegExp('Ã§'), 'c');
    st = st.replaceAll(RegExp('Ä'), 'g');
    st = st.replaceAll(RegExp('Å'), 's');
    st = st.replaceAll(RegExp('Ä°'), 'I');
    st = st.replaceAll(RegExp('Ç'), 'C');
    st = st.replaceAll(RegExp('Å'), 'S');
    st = st.replaceAll(RegExp('Ü'), 'U');
    st = st.replaceAll(RegExp('Ã¶'), 'o');
    st = st.replaceAll(RegExp('Ã'), 'U');
    return st;
  }

  Future getData() async {
    var res = await http.get(url);
    var body = res.body;
    var parsedBody = parser.parse(body);
    var yemeklerString =
    parsedBody.getElementsByTagName("P")[0].innerHtml.split("<br>");
    setState(() {
      for (int i = 0; i < yemeklerString.length - 1; i++) {
        Yemek yemek = Yemek(name: changeTrLetters(yemeklerString[i]), point: 0);
        yemekler.add(yemek);
      }
      mainYemek = yemekler[1];
    });

    setState(() {
      isLoaded = true;
    });
    //1 -> length-3
  }


  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: isLoaded
            ? SafeArea(
          child: Column(
            children: [
              const Text(
                "Gunun Menusu:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: 30, left: 30, top: 50, bottom: 50),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: yemekler.length - 2,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Container(
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,),
                              onPressed: () {
                                setState(() {
                                  mainYemek = yemekler[index+1];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommentPage(mainYemek: mainYemek)));
                                });
                              },
                              child: Flexible(
                                child: Text(
                                  yemekler[index + 1].name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                key: Key("1"),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Image.network(
                          "https://finedine.imgix.net/JzeMu1YhA0/fcd1a22c-ef88-4abb-a653-35ff11712d20.png?auto=format,&fit=crop&w=150"),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Image.network(
                          "https://fastly.4sqi.net/img/general/600x600/82721560_O6yl8w6-A6tQOsdgo08PpG3oSTf3lU4CdzxKC6n_fkQ.jpg"),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
        )
            : Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            )));
  }
}

