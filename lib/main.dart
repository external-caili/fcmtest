import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(new MyApp());

FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Firebase Test App',
      home: new MyHomePage(title: 'Firebase Test App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> _events = [];

  _initFirebase() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        setState(() {
          _events.add({'time': DateTime.now().toString(), 'body': '$message'});
        });
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) => print(token));
  }

  @override
  void initState() {
    super.initState();
    _initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.title)), body: _body());
  }

  Widget _body() {
    if (_events.isEmpty)
      return Center(
        child: Text('Waiting for notifications...',
            style: Theme.of(context).textTheme.subhead),
      );
    else
      return ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        children: _events.map<Widget>((ev) {
          return Card(
            elevation: 2.0,
            child: ListTile(
              title: Text(ev['body']),
              subtitle: Text(ev['time']),
              leading: Icon(Icons.notifications),
              dense: true,
            ),
          );
        }).toList(),
      );
  }
}
