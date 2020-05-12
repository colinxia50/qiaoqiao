import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'player_widget.dart';


class RedEnvelope extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var icon2 = Icon(Icons.arrow_back_ios);
    return MaterialApp(
        home: Scaffold(
          //backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
          appBar: AppBar(
            //backgroundColor: Color.fromRGBO(245, 245, 245, 0.5),
            title: Text('小微',style: TextStyle(fontWeight: FontWeight.w700)),
            leading: IconButton(
                icon: icon2,
                onPressed: () {
                  Navigator.pop(context);
                }),
            actions: <Widget>[Icon(Icons.more_horiz)],
          ),
          body: RedContent(),
        ),
        theme: ThemeData(primaryColor: Colors.grey[200]));
  }
}


//book.flutterchina.club
class RedContent extends StatefulWidget {

  @override
  _RedContentState createState() => _RedContentState();
}

class _RedContentState extends State<RedContent> {
  Map config = {
    "APPID": "1ir0fa0kyLCq2me",
    "TOKEN": "U7dvdW1Ch0c34xHvw0KX1Odc11cC09",
    "EncodingAESKey": "giWiX1JQbWrmtuLf1SE62VCxLTXTD74qeHmz2as280o"
  };

  Map signatureCongig = Map();

  List<Map> _listIiemMsg = [
        {"sender": 0, "type":1,"msg": "哈哈"}
  ];
  bool send = false;

  TextEditingController msgController = TextEditingController();
  ScrollController _controller = ScrollController();




  @override
  void initState() {
    super.initState();
    signature();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Container(
                  color: Colors.grey[200],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            controller: _controller,
                            itemCount: _listIiemMsg.length,
                            itemBuilder: (context, index) {
                              return buildTextMsg(_listIiemMsg[index]);
                            }),
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey[300],
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: IconButton(
                            icon: Image.asset('images/voice.png'),
                            onPressed: null),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          maxLines:null,
                          keyboardType:TextInputType.multiline,
                          controller: msgController,
                          decoration: InputDecoration(
                              filled: true, fillColor: Colors.white),
                          onSubmitted: (value) {
                            print(value);
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                send = false;
                              } else {
                                send = true;
                              }
                            });
                          },
                        ),
                      ),
                      IconButton(
                          iconSize: 32.0,
                          icon: Image.asset('images/mood.png'),
                          onPressed: null),
                      send
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0)),
                              padding: EdgeInsets.only(right: 10.0),
                              child: RaisedButton(
                                  child: Text('发送'),
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if (msgController.text.isNotEmpty) {
                                      setState(() {
                                        _listIiemMsg.insert(0, {
                                          "sender": 1,
                                          "type":1,
                                          "msg": msgController.text
                                        });
                                        aibot(msgController.text);
                                        msgController.clear();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        //_controller.jumpTo(_controller
                                        //     .position.maxScrollExtent);
                                      });
                                    }
                                  }))
                          : IconButton(
                              iconSize: 30.0,
                              icon: Icon(
                                Icons.control_point,
                                color: Colors.black,
                              ),
                              onPressed: null),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }




  //文本消息
  Widget buildTextMsg(MsgMap) {
    print(MsgMap);
    Widget pic = Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[ ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(MsgMap["sender"] == 0?
          "images/1.png":"images/2.png",
          width: 52,
          height: 52,
          fit: BoxFit.cover,
        ),
      ),],),
    );
    Widget textConten;
    if(MsgMap['type']==1){
     textConten = Expanded(
      flex: 6,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Align(
            alignment: MsgMap["sender"] == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: MsgMap["sender"] == 0
                      ? Colors.white
                      : Color.fromRGBO(28, 250, 43, 1.0),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                MsgMap["msg"],
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          MsgMap["sender"] == 0
              ? Positioned(
                  top: 10.0,
                  left: -15.0,
                  child: Image.asset(
                    "images/white.png",
                    width: 30.0,
                    height: 30,
                  ),
                )
              : Positioned(
                  top: 10.0,
                  right: -15.0,
                  child: Image.asset(
                    "images/green.png",
                    width: 30.0,
                    height: 30.0,
                  ),
                )
        ],
      ),
    );
    }else{
      var url = MsgMap["url"].replaceFirst("http", "https");
      textConten=Expanded(
      flex: 6,
      child:PlayerWidget(url:url,albumname:MsgMap["album_name"],albumpicurl:MsgMap["album_pic_url"],author:MsgMap["author"]));
      //textConten=Container(color:Colors.pinkAccent);

    }
    Widget boxs = Expanded(flex: 2, child: Container());
    Widget widgetMsg = Container(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.start,
            //crossAxisAlignment: MsgMap["sender"] == 0
               // ? CrossAxisAlignment.start
               // : CrossAxisAlignment.end,
            children: MsgMap["sender"] == 0
                ? <Widget>[pic, textConten, boxs]
                : <Widget>[boxs, textConten, pic]));
    return widgetMsg;
  }

  signature() async {
    var url = 'https://openai.weixin.qq.com/openapi/sign/${config['TOKEN']}';
    var body = {
      'userid': 'id11223344',
    };
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      signatureCongig = json.decode(response.body);
      signatureCongig["expiresIn"] = signatureCongig["expiresIn"]*1000+DateTime.now().millisecondsSinceEpoch;
      return signatureCongig;
    } else {
      throw Exception('Failed to fetch data.');
    }
  }

  aibot(msg) async {
    if (DateTime.now().millisecondsSinceEpoch > signatureCongig["expiresIn"]) {
      Future(() => signature()).then((m) => aibotData(m, msg));
    } else {
      aibotData(signatureCongig, msg);
    }
  }

  aibotData(m, msg) async {
    var url = 'https://openai.weixin.qq.com/openapi/aibot/${config['TOKEN']}';
    var body = {'query': msg, 'signature': m["signature"]};
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        if(data["answer_type"]=="music"){
          var datas = data["more_info"].containsKey("music_ans_detail")?data["more_info"]["music_ans_detail"]:data["more_info"]["fm_ans_detail"];
              datas = json.decode(datas);
              datas = datas.containsKey("play_command")?datas["play_command"]:datas["audio_play_command"];
           _listIiemMsg.insert(0, {"sender": 0,
           "type":2,
            "url": datas["play_list"][0]["url"],
            "album_pic_url": datas["play_list"][0]["album_pic_url"],
            "author": datas["play_list"][0]["author"],
            "album_name": datas["play_list"][0]["album_name"],
            });
        }else{
        _listIiemMsg.insert(0, {"sender": 0,"type":1, "msg": data["msg"][0]["content"]});
        }
      });
    } else {
      throw Exception('Failed to fetch data.');
    }
  }
}
