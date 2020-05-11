import 'package:flutter/material.dart';

class AticleShow extends StatelessWidget {

  final arguments;
  AticleShow({this.arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text(arguments['title'],),
        elevation: 0.0,
        centerTitle: true
      ),
      body:SingleChildScrollView(
        child: Column(
        children: <Widget>[
          Image.network(
           arguments['image'].length!=0?arguments['image']:'https://pic1.zhimg.com/80/bfbf4c8961cc4e788b41b48b43c3639d_720w.jpg',
            ),
            Container(
              padding: EdgeInsets.all(32.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(arguments['title'],style: Theme.of(context).textTheme.title,),
                  SizedBox(height: 32.0,),
                  Text(
                    arguments['story'],
                    style: TextStyle(
                      fontSize: 24.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                  )),
                ],
              ),
            ),
        ],
      ),
      ),
    );
  }
}