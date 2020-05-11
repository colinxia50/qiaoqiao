import 'dart:async';

import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'dart:math';

class NotStupid extends StatefulWidget {
  NotStupid({Key key}) : super(key: key);

  @override
  _NotStupidState createState() => _NotStupidState();
}

class _NotStupidState extends State<NotStupid> {
  List items = [
    '1',
    '2',
    '3',
    '+',
    '4',
    '5',
    '6',
    '-',
    '7',
    '8',
    '9',
    '*',
    '0',
    '10',
    '11',
    '/'
  ];
  RandomColor _randomColor = RandomColor();

  List<int> input = List();
  List<String> tag = List();
  String temp = '';
  String temp1 = '';
  String inputAnswer = '';
  int answer = Random().nextInt(100);
  int score = 0;

  String _verifyStr = '计时';
  Timer timer;
  int _seconds = 60;
  bool isClickDisable = false;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('分数：' + score.toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: _randomColor.randomColor(),
                  )),
              InkWell(
                  child: Text('$_verifyStr',
                      style: TextStyle(
                          fontSize: 20.0, color: _randomColor.randomColor())),
                  onTap: !isClickDisable
                      ? () {
                          isClickDisable = true;
                          timer = Timer.periodic(Duration(seconds: 1), (timer) {
                            if (_seconds == 0) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('成绩'),
                                      content: Text('得分: $score !加强练习哦！'),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('确定'))
                                      ],
                                    );
                                  });
                              isClickDisable = false;
                              timer?.cancel();
                              _seconds = 60;
                              _verifyStr = '计时';
                              tag.clear();
                              temp = '';
                              temp1 = '';
                              inputAnswer = '';
                              answer = Random().nextInt(100);
                              score = 0;
                              setState(() {});
                              return;
                            }
                            _seconds--;
                            _verifyStr = _seconds.toString();
                            setState(() {});
                          });
                        }
                      : null),
            ],
          )),
      Expanded(
        flex: 3,
        child: _buildDragTargetBox(),
      ),
      Expanded(
        flex: 6,
        child: _buildWrapChild(),
      )
    ]);
  }

  Widget _buildWrapChild() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, childAspectRatio: 1.2),
      physics: new NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildDragBox(items[index], _randomColor);
      },
    );
  }

  Widget _buildDragTargetBox() {
    RandomColor _randomColor = RandomColor();
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return Container(
            child: Center(
                child: Column(
              children: <Widget>[
                Text(
                  'X ? X = ' + answer.toString(),
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: _randomColor.randomColor(
                        colorSaturation: ColorSaturation.highSaturation),
                  ),
                ),
                SizedBox(height: 20.0),
                inputAnswer.isEmpty
                    ? Text(
                        '拖入此处，使等式成立。',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: _randomColor.randomColor(),
                        ),
                      )
                    : Text(
                        inputAnswer,
                        style: TextStyle(
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                          color: _randomColor.randomColor(
                              colorSaturation: ColorSaturation.highSaturation),
                        ),
                      )
              ],
            )),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              border: Border.all(
                color: Colors.red,
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ));
      },
      onWillAccept: (v) {
        return true;
      },
      onAccept: (v) {
        var answerLeng = inputAnswer.length;
        setState(() {
          switch (v) {
            case '+':
              if (answerLeng != 0) {
                if (tag.isNotEmpty) {
                  var tempAnswer = countValue(temp, temp1, tag[0]);
                  temp = tempAnswer.toString();
                  temp1 = '';
                  tag[0] = '+';
                } else {
                  tag.add('+');
                }
                inputAnswer = inputAnswer + '➕';
              }
              break;
            case '-':
              if (answerLeng != 0) {
                if (tag.isNotEmpty) {
                  var tempAnswer = countValue(temp, temp1, tag[0]);
                  temp = tempAnswer.toString();
                  temp1 = '';
                  tag[0] = '-';
                } else {
                  tag.add('-');
                }
                inputAnswer = inputAnswer + '➖';
              }
              break;
            case '*':
              if (answerLeng != 0) {
                if (tag.isNotEmpty) {
                  var tempAnswer = countValue(temp, temp1, tag[0]);
                  temp = tempAnswer.toString();
                  temp1 = '';
                  tag[0] = '*';
                } else {
                  tag.add('*');
                }
                inputAnswer = inputAnswer + '✖';
              }
              break;
            case '/':
              if (answerLeng != 0) {
                if (tag.isNotEmpty) {
                  var tempAnswer = countValue(temp, temp1, tag[0]);
                  temp = tempAnswer.toString();
                  temp1 = '';
                  tag[0] = '/';
                } else {
                  tag.add('/');
                }
                inputAnswer = inputAnswer + '➗';
              }
              break;
            case '10':
              if (answerLeng != 0) {
                var tempAnswer = countValue(temp, temp1, tag[0]);
                if (answer == tempAnswer) {
                  score += 100;
                }
                tag.clear();
                temp = '';
                temp1 = '';
                answer = Random().nextInt(100);
                inputAnswer = '';
              }
              break;
            case '11':
              if (answerLeng != 0) {
                tag.clear();
                temp = '';
                temp1 = '';
                inputAnswer = '';
              }
              break;
            default:
              if (tag.isNotEmpty) {
                temp1 = temp1 + v;
              } else {
                temp = temp + v;
              }
              inputAnswer = inputAnswer + v;
              break;
          }
        });

        //print(v);
      },
      onLeave: (moveIndex) {},
    );
  }

  Widget _buildDragBox(value, _randomColor) {
    return Draggable(
      data: value,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFFFF00), width: 2.0),
          color:
              _randomColor.randomColor(colorBrightness: ColorBrightness.light),
          shape: BoxShape.circle,
        ),
        child: _buildEmojiCenter(value),
      ),
      feedback: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _randomColor.randomColor(), width: 2.0),
          color: _randomColor.randomColor(),
          borderRadius: BorderRadius.all(Radius.circular(150.0)),
        ),
        width: 160,
        height: 160,
        child: _buildEmojiCenter(value),
      ),
    );
  }

  Widget _buildEmojiCenter(value) {
    var textEmoji = value;
    if (value == '10') {
      textEmoji = '😀';
    } else if (value == '11') {
      textEmoji = '😭';
    }
    return Center(
      child: Text(
        value == '10' ? '😀' : textEmoji,
        textAlign: TextAlign.center,
        style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 48.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  countValue(v1, v2, tag) {
    var an;
    v1 = int.parse(v1);
    v2 = int.parse(v2);
    switch (tag) {
      case '+':
        an = v1 + v2;
        break;
      case '-':
        an = v1 - v2;
        break;
      case '*':
        an = v1 * v2;
        break;
      case '/':
        an = v1 / v2;
        break;
    }
    return an;
  }
}
