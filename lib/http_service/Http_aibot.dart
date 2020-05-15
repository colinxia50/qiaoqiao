import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpAibot{
    Map config = {
    "APPID": "1ir0fa0kyLCq2me",
    "TOKEN": "U7dvdW1Ch0c34xHvw0KX1Odc11cC09",
    "EncodingAESKey": "giWiX1JQbWrmtuLf1SE62VCxLTXTD74qeHmz2as280o"
  };

  Map signatureMap = Map();

  HttpAibot(){
    _signature();
  }

    _signature() async {
    var url = 'https://openai.weixin.qq.com/openapi/sign/${config['TOKEN']}';
    var body = {
      'userid': 'id11223344',
    };
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      signatureMap = json.decode(response.body);
      signatureMap["expiresIn"] = signatureMap["expiresIn"]*1000+DateTime.now().millisecondsSinceEpoch;
      return signatureMap;
    } else {
      throw Exception('Failed to fetch data.');
    }
  }

  aibot(msg) async {
    if (DateTime.now().millisecondsSinceEpoch > signatureMap["expiresIn"]) {
      return Future(() => _signature()).then((m) => aibotData(msg));
    } else {
      return aibotData(msg);
    }
  }

  Future<Map>aibotData(msg) async {
    var url = 'https://openai.weixin.qq.com/openapi/aibot/${config['TOKEN']}';
    var body = {'query': msg, 'signature': signatureMap["signature"]};
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
        if(data["answer_type"]=="music"){
          var datas = data["more_info"].containsKey("music_ans_detail")?data["more_info"]["music_ans_detail"]:data["more_info"]["fm_ans_detail"];
              datas = json.decode(datas);
              datas = datas.containsKey("play_command")?datas["play_command"]:datas["audio_play_command"];
           return {"sender": 0,
           "type":2,
            "url": datas["play_list"][0]["url"],
            "album_pic_url": datas["play_list"][0]["album_pic_url"],
            "author": datas["play_list"][0]["author"],
            "album_name": datas["play_list"][0]["album_name"],
            };
        }else{
        return {"sender": 0,"type":1, "msg": data["msg"][0]["content"]};
        }
    } else {
      throw Exception('Failed to fetch data.');
    }
  }
}