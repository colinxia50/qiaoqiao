import 'package:flutter/material.dart';
import 'tabs/Home.dart';
import 'tabs/Jigsaw.dart';
import 'tabs/Test.dart';
import 'tabs/NotStupid.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  List _pageLists = [
    Home(),
    Jigsaw(),
    NotStupid(),
    TestPage(),
  ];
  List _appbarLists = [
    Text('图片与故事'),
    Text('精美拼图'),
    Text('算术小能手'),
    Text('测试页'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: _appbarLists[this._currentIndex], centerTitle: true),
      body: _pageLists[this._currentIndex],
/*       bottomNavigationBar: BottomNavigationBar(
          currentIndex: this._currentIndex,
          onTap: (int index) {
            setState(() {
              this._currentIndex = index;
            });
            print(index);
          },
          iconSize: 45.0,
          fixedColor: Colors.red,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), title: Text('分类')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('设置')),
          ]), */
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: DrawerHeader(
                    child: Column(
                      children: <Widget>[
                        ClipOval(
                            child: Image.asset(
                          "images/tabs.webp",
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                        )),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            '瞧瞧',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            '曾看过一个小段子',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(22, 11, 12, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  ),
                )
              ],
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor:Colors.black,
                child: Icon(Icons.stars,color: Colors.white,),
              ),
              title: Text('看个故事'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  this._currentIndex = 0;
                  });
              },
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                 backgroundColor:Colors.black,
                child: Icon(Icons.spa,color: Colors.white),
              ),
              title: Text('就一个图'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  this._currentIndex = 1;
                  });
              },
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                 backgroundColor:Colors.black,
                child: Icon(Icons.spa,color: Colors.white),
              ),
              title: Text('拒绝痴呆'),
                onTap: () {
                Navigator.pop(context);
                setState(() {
                  this._currentIndex = 2;
                  });
              },
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                 backgroundColor:Colors.black,
                child: Icon(Icons.thumb_up,color:Colors.white),
              ),
              title: Text('聊会吧'),
              onTap: () {
                Navigator.pushNamed(context, '/RedEnvelope');

              },
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                 backgroundColor:Colors.black,
                child: Icon(Icons.thumb_up,color:Colors.white),
              ),
              title: Text('test'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  this._currentIndex = 3;
                  });
              },
            ),
          ],
        ),
      ),
    );
  }
}
