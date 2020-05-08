import 'package:flutter/material.dart';
import './firsttab.dart' as firsttab;
import './secondtab.dart' as secondtab;
import './webview.dart' as webview;

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 3);
  }

  @override
  //disposing the tab after removing from tree
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(30.0), // here the desired height
            child: AppBar(
              centerTitle: true,
              title: Text('Genre Identification '),
            )),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            webview.webviewTab(),
            firsttab.FirstTab(),
            secondtab.SecondTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (currentIndex) {
            setState(() {
              _currentIndex = currentIndex;
            });

            controller.animateTo(_currentIndex);
          },
          items: [
            BottomNavigationBarItem(
                title: Text("WebView"), icon: Icon(Icons.web)),
            BottomNavigationBarItem(
                title: Text("Home"), icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                title: Text("2D Graph"), icon: Icon(Icons.graphic_eq))
          ],
        ),
      ),
    );
  }
}
//http://35.193.25.142/
