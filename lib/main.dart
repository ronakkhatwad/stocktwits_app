import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stocktwits_app/authentication_page.dart';
import 'package:stocktwits_app/watchlist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var token = "";
  var watchlist = [];
  void getToken() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AuthenticationPage(),
        )).then((value) {
      setState(() {
        token = value;
      });
    });
    getWatchlist();
  }

  getWatchlist() async {
    var url = 'https://api.stocktwits.com/api/2/watchlists.json?access_token=' +
        token;
    var response;
    await http.get(Uri.parse(url)).then((value) {
      setState(() {
        response = jsonDecode(value.body);
        watchlist = response['watchlists'];
      });
      // print(response['watchlists'][0]['name']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) => getToken());
    //getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: watchlist.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    watchlist[index]['name'],
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Updated : ${watchlist[index]['updated_at']}'),
                    Text('Created : ${watchlist[index]['created_at']}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WatchList(
                                title: watchlist[index]['name'],
                                watchListID: watchlist[index]['id'].toString(),
                                token: token,
                              )));
                },
              );
            }),
      ),
    );
  }
}
