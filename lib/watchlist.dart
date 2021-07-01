import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WatchList extends StatefulWidget {
  final String title;
  final String watchListID;
  final String token;
  WatchList({this.token, this.title, this.watchListID});
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  var symbols = [];
  getWatchlist() async {
    var url = 'https://api.stocktwits.com/api/2/watchlists/show/' +
        widget.watchListID +
        '.json?access_token=' +
        widget.token;
    var response;
    await http.get(Uri.parse(url)).then((value) {
      setState(() {
        response = jsonDecode(value.body);
        symbols = response['watchlist']['symbols'];
      });
      // print(response['watchlists'][0]['name']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getWatchlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: symbols.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  symbols[index]['symbol'],
                ),
                subtitle: Text(
                  symbols[index]['title'],
                ),
              );
            }),
      ),
    );
  }
}
