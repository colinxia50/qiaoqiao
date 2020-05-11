import 'dart:async';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  
  @override
  Widget build(BuildContext context) {

    return Column(children: <Widget>[
        Center(
        child: Container(
          width: 300,
          height: 300,
          color: Colors.red,
          child: Text('惊不惊喜，意不意外。',style: TextStyle(fontSize: 48.0,color: Colors.white ))
        ),
      ),
      FormCode(
        available:true,
        countdown: 10,
        onTapCallback: (){
          print('haha');
        }),
      ],);
  }
}



final TextStyle _availableStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.pink[300],
);

final TextStyle _unavailableStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.grey[400],
);

/*
* 倒计时按钮
*/
class FormCode extends StatefulWidget {
  final int countdown; //倒计时的秒数，默认60秒
  final Function onTapCallback; //用户点击时的回调函数
  final bool available;

  FormCode(
      {this.countdown,
      this.onTapCallback,
      this.available = false}); //是否可以获取验证码，默认为"false"

  @override
  State createState() => _FormCodeState();
}

class _FormCodeState extends State<FormCode> {
  Timer _timer; //倒计时的计时器
  int _seconds; //当前倒计时的秒数
  TextStyle inkWellStyle = _availableStyle; //当前墨水瓶（"InkWell"）的字体样式
  String _verifyStr = "获取验证码"; ////当前墨水瓶（"InkWell"）的文本
  bool isClickDisable=false;//防止点击过快导致Timer出现无法停止的问题
  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //启动倒计时计时器
  void _startTimer() {
    isClickDisable=true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _seconds = widget.countdown;
        inkWellStyle = _availableStyle;
        _verifyStr = "重新发送";
        setState(() {});
        _cancleTimer();
        return;
      }
      _seconds--;
      _verifyStr = "已发送$_seconds" + "s";
      setState(() {});
    });
  }

  //取消到倒计时的计时器
  void _cancleTimer() {
    isClickDisable=false;
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //墨水瓶组件，响应触摸的矩形区域
    if(isClickDisable==null){
      isClickDisable=false;//防止空指针异常
    }
    return widget.available
        ? InkWell(
            child: Text(
              '$_verifyStr',
              style: inkWellStyle,
            ),
            onTap: (_seconds == widget.countdown)&&!isClickDisable
                ? () {
                     _startTimer();
                     inkWellStyle = _unavailableStyle;
                     _verifyStr = "已发送$_seconds" + "s";
                     setState(() {});
                     widget.onTapCallback();
                  }
                : null,
          )
        : InkWell(
            child: Text(
              "获取验证码",
              style: _unavailableStyle,
            ),
          );
  }
}