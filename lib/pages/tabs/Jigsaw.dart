import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Jigsaw extends StatefulWidget {
  Jigsaw({Key key}) : super(key: key);

  @override
  _JigsawState createState() => _JigsawState();
}

class _JigsawState extends State<Jigsaw> {
  List<Widget> clippers = List();
  var status = 1;
  String pic='';
  @override
  void initState() {
    super.initState();
    fetchPic();
  }

  openPicDialog(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
          height: 800.0,
          child: Image.network(pic, fit: BoxFit.cover),);
      }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _buildGridChildren(context),
        ),
        Expanded(
            flex: 1,
            child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        child: Text('拼图'),
                        color: Colors.pinkAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        onPressed: (){
                          if(clippers.isEmpty){
                            clip();
                          }
                        }),
                    SizedBox(width: 16.0),
                    RaisedButton(
                        child: Text('下一张'),
                        color: Colors.pinkAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          setState(() {
                            clippers.clear();
                            fetchPic();
                            status=1;
                            });
                        }),
                    SizedBox(width: 64.0),
                    RaisedButton(
                        child: Text('原图'),
                        color: Colors.greenAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        onPressed: openPicDialog,
                        ),
                  ],
                ),
               ))
      ],
    );
  }

  Widget _buildGridChildren(BuildContext context) {
    Widget pagesOne = Center(
      child: CircularProgressIndicator()
    );
    if (pic.length!=0) {
      pagesOne = Container(child: Image.network(pic, fit: BoxFit.cover));
    }
    if (status == 1) {
      return pagesOne;
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
          crossAxisCount: 2,
        ),
        physics: new NeverScrollableScrollPhysics(),
        itemCount: clippers.length,
        itemBuilder: (context,index){
          return draggableItem(index);
        },

      );
    }
  }

  void fetchPic() async {
    var url = 'https://api.berryapi.net/';
    var body = {
      'service': 'App.Bing.Images',
      'AppKey': 'GpewGX7zHzrzS3BB',
      'formate': '2',
      'rand': '1',
    };
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      pic = json.decode(response.body)['data']['img'];
      setState(() {});
    } else {
      throw Exception('Failed to fetch data.');
    }
  }

  Future<ui.Image> _loadImge() async {
    ImageStream imageStream = NetworkImage(pic).resolve(ImageConfiguration());
    Completer<ui.Image> completer = Completer<ui.Image>();
    void imageListener(ImageInfo info, bool synchronousCall) {
      ui.Image image = info.image;
      completer.complete(image);
      imageStream.removeListener(ImageStreamListener(imageListener));
    }

    imageStream.addListener(ImageStreamListener(imageListener));
    return completer.future;
  }

  clip() async {
    ui.Image uiImage;

    _loadImge().then((image) {
      uiImage = image;
    }).whenComplete(() {
      List<Map<String,double>> param=[
        {"left": 0,"top": 0, "right": 0.5, "bottom": 0.5},
        {"left": 0.5,"top": 0, "right": 1.0, "bottom": 0.5},
        {"left": 0,"top": 0.5, "right": 0.5, "bottom": 1.0},
        {"left": 0.5,"top": 0.5, "right": 1.0, "bottom": 1.0},
      ];
      param.shuffle();

      Future imgeClipperList(uiIm,v)async{
        ImageClipper clipper1 =ImageClipper(uiIm,v);
        Widget test1 = Container(
          color: Colors.green,
          child: CustomPaint(
            painter: clipper1,
          ));
        clippers.add(test1);

      }
      param.forEach((value)async{
        await imgeClipperList(uiImage,value);
        
      });

      setState(() {
        status = 2;
      });
    });
  }

  Widget draggableItem(value) {
    return Draggable(
      data: value,
      child: DragTarget(
        builder: (context, candidateData, rejectedData) {
          return clippers[value];
        },
        onWillAccept: (moveIndex) {
          print('=== onWillAccept: ');

          return true;
        },
        onAccept: (moveIndex) {
        setState(() {
          var temp = clippers[value];
          clippers[value]=clippers[moveIndex];
          clippers[moveIndex]=temp;
        });
          print('=== onAccept:');
        },
        onLeave: (moveIndex) {
          print('=== onLeave:');
        },
      ),
      feedback: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFF0000), width: 0.5),
          color: Color(0xFF9E9E9E),
          borderRadius: BorderRadius.circular((20.0)),
        ),
        width: 220,
        height: 220,
        child: clippers[value],
      ),
      childWhenDragging: Container(
        color: Colors.blueAccent,
        child: Center(child: Image.asset(
                          "images/tabs.webp",
                          fit: BoxFit.cover,
                        ),),
        ),
      onDragStarted: () {
        print('=== onDragStarted===uuuuuuuuuuuuu');
      },
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        print('=== onDraggableCanceled');
      },
      onDragCompleted: () {
        print('=== onDragCompleted');
      },
    );
  }
}

/// 图片裁剪
class ImageClipper extends CustomPainter {
  final ui.Image image;
  final v;

  ImageClipper(this.image, this.v);
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();
    canvas.drawImageRect(
        image,
        Rect.fromLTRB(image.width * v['left'], image.height * v['top'],
            image.width * v['right'], image.height * v['bottom']),
        Rect.fromLTWH(0, 0, size.width, size.height),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
