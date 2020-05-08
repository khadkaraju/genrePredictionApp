import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const ourURL = "http://35.193.25.142/";

class webviewTab extends StatefulWidget {
  @override
  _webviewTabState createState() => _webviewTabState();
}

class _webviewTabState extends State<webviewTab> {
  Future launchlURL(String url) async {
    if (await canLaunch((url))) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      print("Can't Launch ${url}");
    }
  }

  TextEditingController controllerr = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  var urlString = "https://youtube.com";

  Expanded buildKey({String link}) {
    return Expanded(
      child: IconButton(
        icon: Icon(Icons.arrow_forward),
        onPressed: () {
          launchlURL(link);
        },
      ),
    );
  }

//  @override
//  void initState() {
//    super.initState();
//
//    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
//      print(wvs.type);
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(95), // here the desired height
          child: AppBar(
            actions: <Widget>[
              buildKey(link: ourURL),
            ],
          )),
      body: WebviewScaffold(
        url: urlString,
        withZoom: false,
      ),
    ));
  }
}
