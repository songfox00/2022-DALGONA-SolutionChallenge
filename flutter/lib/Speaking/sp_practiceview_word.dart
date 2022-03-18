import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
// import 'package:camera/camera.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class SpWordPracticePage extends StatefulWidget {
  //const SpLetterPracticePage({Key? key}) : super(key: key);
  @override
  _SpWordPracticePageState createState() => _SpWordPracticePageState();
}

class _SpWordPracticePageState extends State<SpWordPracticePage> {


  bool _isStared = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '.';
  String _practiceText ='단어';

  double _confidence = 1.0;
  double _videoSpeed = 1.0;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;


  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://user-images.githubusercontent.com/44363187/159072414-a97097b5-5eac-4850-987b-fb755d0fe06d.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    super.initState();
    _speech = stt.SpeechToText();

  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "단어 연습",
                style: TextStyle(
                    color: Color(0xff333333), fontSize: 24, fontWeight: FontWeight.w800),
              ),
              centerTitle: true,
              foregroundColor: Color(0xff333333),
              backgroundColor: Color(0xffC8E8FF),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: AvatarGlow(
              animate: _isListening,
              glowColor: Color(0xffC8E8FF),
              endRadius: 75.0,
              duration: const Duration(milliseconds: 2000),
              repeatPauseDuration: const Duration(milliseconds: 100),
              repeat: true,
              child: FloatingActionButton(
                onPressed: _listen,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
            ),
            body: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0, bottom: 15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "다음 글자를 발음해 보세요!",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                            onPressed: _pressedStar,
                            icon: (_isStared
                                ? Icon(Icons.star)
                                : Icon(Icons.star_border)),
                            iconSize: 25,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: FutureBuilder(
                                  future: _initializeVideoPlayerFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return AspectRatio(
                                        aspectRatio: 270/100,
                                        child: VideoPlayer(_controller),
                                      );
                                    } else {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                                height: 210,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: ElevatedButton(
                                        onPressed: (){
                                          setState(() {
                                            if (_controller.value.isPlaying) {
                                              _controller.pause();
                                            } else {
                                              _controller.play();
                                            }
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xffC8E8FF),
                                          minimumSize: Size(35, 25),
                                          padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: Icon(
                                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                          size: 20,
                                          color: Color(0xff97D5FE),
                                        ),
                                      )
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                            child: ElevatedButton(
                                              onPressed: (){
                                                setState(() {
                                                  if(_videoSpeed>0.25){
                                                    _videoSpeed -= 0.25;
                                                  }
                                                });
                                                _controller.setPlaybackSpeed(_videoSpeed);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(0xffC8E8FF),
                                                minimumSize: Size(35, 25),
                                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                size: 20,
                                                color: Color(0xff97D5FE),
                                              ),
                                            )
                                        ),
                                        Container(
                                          child: Text(
                                              '$_videoSpeed'
                                          ),
                                          width: 30,
                                        ),
                                        Container(
                                            child: ElevatedButton(
                                              onPressed: (){
                                                setState(() {
                                                  if(_videoSpeed < 1.5){
                                                    _videoSpeed += 0.25;
                                                  }
                                                });
                                                _controller.setPlaybackSpeed(_videoSpeed);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(0xffC8E8FF),
                                                minimumSize: Size(35, 25),
                                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Color(0xff97D5FE),
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )


                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffC8E8FF),
                          ),
                          height: 70,
                          child: Center(
                            child: Text(
                              '$_practiceText',
                              style: TextStyle(
                                fontSize: 38, fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30.0, bottom: 15.0),
                        child: Row(
                          children: [
                            Text(
                              "다음과 같이 발음하고 있습니다.",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ),

                      // Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(5),
                      //       color: Color(0xffC8E8FF),
                      //     ),
                      //     margin: EdgeInsets.only(top: 10.0, bottom:15.0),
                      //     height: 130,
                      //     child: Center(
                      //       child: Text(
                      //         'camera',
                      //         style: TextStyle(
                      //           fontSize: 38, fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //     )
                      // ),

                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xff97D5FE),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            height: 70,
                            child: Container(
                              child: Center(
                                child: Text(
                                  '${_text}',
                                  style: const TextStyle(
                                    fontSize: 38.0,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            )
        )
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _pressedStar() {
    setState(() {
      if (_isStared) {
        _isStared = false;
      } else {
        _isStared = true;
      }
    });
  }
}
