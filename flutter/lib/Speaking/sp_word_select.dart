import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:zerozone/Login/login.dart';
import 'package:zerozone/Speaking/sp_word_consonant.dart';
import 'dart:convert';

import 'sp_practiceview_word.dart';

class WordSelectPage extends StatefulWidget {

  final String consonant;
  final List<WordList> wordList;

  const WordSelectPage({Key? key, required this.consonant, required this.wordList}) : super(key: key);

  @override
  State<WordSelectPage> createState() => _WordSelectPageState();
}

class _WordSelectPageState extends State<WordSelectPage> {

  Future<void> urlInfo(String letter, int index) async {

    Map<String, String> _queryParameters = <String, String>{
      'id' : index.toString(),
    };

    var url = Uri.http('localhost:8080', '/speaking/practice/word', _queryParameters);

    var response = await http.get(url, headers: {'Accept': 'application/json', "content-type": "application/json", "Authorization": "Bearer ${authToken}" });

    print(url);

    if (response.statusCode == 200) {
      print('Response body: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      var body = jsonDecode(utf8.decode(response.bodyBytes));

      dynamic data = body["data"];

      String url = data["url"];
      String type = data["type"];
      int probId = data["probId"];

      print("url : ${url}");
      print("type : ${type}");


      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SpWordPracticePage(url: url, type: type, probId: probId, word: letter,))
      );

    }
    else {
      print('error : ${response.reasonPhrase}');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '말하기 연습 - 단어',
          style: TextStyle(color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xffC8E8FF),
        foregroundColor: Color(0xff333333),
      ),

      body: new Container(
         margin: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
         padding: EdgeInsets.only(left: 10.0, right: 10.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Container(
              margin: EdgeInsets.only(bottom: 40.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Color(0xff5AA9DD),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              width: 300,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                '선택한 자음: ${widget.consonant}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              width: 300,
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     width: 2,
                //     color: Colors.grey,
                //   ),
                //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                // ),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.wordList.length,
                    itemBuilder: (context, idx){
                      return GestureDetector(
                        onTap: (){
                          urlInfo(widget.wordList[idx].word, widget.wordList[idx].index);

                        },
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            widget.wordList[idx].word,
                            style: TextStyle(fontSize: 15),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              )),

                        ),

                      );
                    }
                )
            ),
          ],
        ),
      ),


    );
  }
}
