import 'package:flutter/material.dart';
import '../../http_service/Http_aibot.dart';
import '../widgets/player_widget.dart';


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
  List<Map> _listIiemMsg = [
        {"sender": 0, "type":1,"msg": "哈哈"}
  ];
  bool send = false;
  TextEditingController msgController = TextEditingController();
  ScrollController _controller = ScrollController();
  HttpAibot httpAibot = HttpAibot();
  @override
  void initState() {
    super.initState();
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
                            if(value.length==1){
                              send = true;
                              setState((){});
                            }
                            if(value.length==0){
                              send = false;
                              setState((){});
                            }
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
                                       httpAibot.aibot(msgController.text).then((v) {
                                         setState((){
                                           _listIiemMsg.insert(0, v);
                                         });

                                       });
 
                                        msgController.clear();

                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
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
    //print(MsgMap);
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

}
