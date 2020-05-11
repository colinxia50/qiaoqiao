import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var posts=List();
  int initialPage=1;



  @override
  void initState() {
    super.initState();
  }


  Future <List> fetchData() async {
    var url = 'https://api.berryapi.net/';
    var body = {
      'service':'App.Bing.Randstory',
      'AppKey':'GpewGX7zHzrzS3BB'
      };
    final response = await http.post(url,body:body);
    if(response.statusCode==200){
      final responseBody = json.decode(response.body)['data']['primary'];
      posts.add(responseBody);
      return posts;
    }else{
      throw Exception('Failed to fetch data.');
    }

  }

  Widget _pageItemBuilder(BuildContext context,int index){
    return Stack(
      children: <Widget>[
        SizedBox.expand(
          child: posts[index]['image'].length!=0?Image.network(
            posts[index]['image'],
            fit: BoxFit.cover
          ):Container(color:Colors.pinkAccent,child: Center(child: Text('这是默认图🤣',style: TextStyle(fontSize: 42.0,color:Colors.white)),)),
        ),
        Positioned(
          bottom: 10.0,
          left: 8.0,
          right: 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                posts[index]['title'],
                style:TextStyle(
                  fontSize: 28.0,
                  color:Colors.white,
                 fontWeight: FontWeight.bold 
                )),
                Text(
                   posts[index]['story'],
                   overflow: TextOverflow.ellipsis,
                  style:TextStyle(
                    fontSize: 20.0,
                    color:Colors.white,
                  ),
                  )
            ],
        )
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor:Colors.white.withOpacity(0.3),
              highlightColor:Colors.white.withOpacity(0.1),
              onTap: (){
                Navigator.pushNamed(context, '/AticleShow',arguments:posts[index]);
              },
            ),
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
            future: fetchData(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              //print(snapshot);
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(
                  child: Text('加载中...'),
                );
              }
               return PageView.builder(
                 scrollDirection: Axis.vertical,
                 itemCount: posts.length,
                 itemBuilder: _pageItemBuilder,
                 controller:PageController(
                   initialPage: initialPage,
                   keepPage: true
                 ),
                 onPageChanged: (currentPage){
                   if(currentPage+1==posts.length){
                     fetchData();
                    setState(() {
                      initialPage=currentPage;
                    });
                   }

                 },
                ); 

            },
            );
  }
}