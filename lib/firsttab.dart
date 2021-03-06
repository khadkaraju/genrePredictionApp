import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

const PopURL =
    "https://www.youtube.com/watch?v=lfCy78dbcYA&list=RDlfCy78dbcYA&start_radio=1";
const FolkURL = "https://www.bensound.com/royalty-free-music/acoustic-folk";
const RockURL = "https://www.bensound.com/royalty-free-music/rock";
const ElectricURL = "https://www.bensound.com/royalty-free-music/electronica";

class FirstTab extends StatefulWidget {
  @override
  _FirstTabState createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {
  Future launchlURL(String url) async {
    if (await canLaunch((url))) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      print("Can't Launch ${url}");
    }
  }

  final _firestore = Firestore.instance;

  void dataStream() async {
    await for (var snapshot in _firestore.collection('mfcc').snapshots()) {
      for (var genreD in snapshot.documents) {
        print(genreD.data);
      }
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              document['name'],
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffddddff),
            ),
            child: Text(
              document['predictedGenre'].toString(),
              style: Theme.of(context).textTheme.headline,
            ),
          )
        ],
      ),
    );
  }

  Expanded buildKey({String link, String image}) {
    return Expanded(
      child: FlatButton(
        onPressed: () {
          launchlURL(link);
        },
        child: Image(
          image: AssetImage('images/$image'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Builder(builder: (BuildContext context) {
              return Center(
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.orange,
                  child: Text('Press & Play Music',
                      style: TextStyle(fontSize: 20.0)),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                  splashColor: Colors.red,
                  onPressed: () {},
                  onLongPress: () {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: StreamBuilder(
                          stream:
                              Firestore.instance.collection('mfcc').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return const Text('Loading...');
                            else {
                              return ListView.builder(
                                itemExtent: 80.0,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) => _buildListItem(
                                    context, snapshot.data.documents[index]),
                              );
                            }
                          }),
                    ));
                  },
                ),
              );
            }),
            SizedBox(
              height: 10.0,
              width: 50.0,
            ),
            Row(
              children: <Widget>[
                buildKey(link: FolkURL, image: 'Folk.png'),
                buildKey(link: PopURL, image: 'Pop.png'),
              ],
            ),
            Row(
              children: <Widget>[
                buildKey(link: RockURL, image: 'Rock.png'),
                buildKey(link: ElectricURL, image: 'Electronic.png'),
              ],
            ),
            SizedBox(
              child: Text("Predicted Genre: "),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
              width: 400,
              height: 150,
              child: StreamBuilder(
                  stream: Firestore.instance.collection('mfcc').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Text('Loading...');
                    else {
                      return ListView.builder(
                        itemExtent: 90.0,
                        itemCount: 1,
                        itemBuilder: (context, index) => _buildListItem(
                            context, snapshot.data.documents[index]),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
