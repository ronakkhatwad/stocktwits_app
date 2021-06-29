import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  static const String CLIENT_ID = "07739410a4530cc2";
  static const String CLIENT_SECRET =
      "45190f1f6f02b2177bc8f542e85fa1235c395a2b";
  static const String initialUrl =
      "https://api.stocktwits.com/api/2/oauth/authorize?client_id=" +
          CLIENT_ID +
          "&response_type=code&redirect_uri=http://www.myappname.com&scope=read,watch_lists,publish_messages,publish_watch_lists,direct_messages,follow_users,follow_stocks";
  WebViewController _controller;
  var currentURL;
  var code = "";
  var token = "";

  getToken() async {
    String tokenUrl = "https://api.stocktwits.com/api/2/oauth/token";
    var response;
    await http.post(Uri.parse(tokenUrl), body: {
      'client_id': CLIENT_ID,
      'client_secret': CLIENT_SECRET,
      'grant_type': 'authorization_code',
      'redirect_uri': 'http://www.myappname.com',
      'code': code,
    }).then((value) {
      response = jsonDecode(value.body);
    });
    setState(() {
      token = response['access_token'];
      print(token);
    });

    Navigator.pop(context, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: WebView(
            initialUrl: initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
            onWebViewCreated: (WebViewController controller) {
              _controller = controller;
            },
            onPageFinished: (url) {
              _controller.currentUrl().then((value) {
                setState(() {
                  currentURL = url;
                });
                print(url);
                var redirectDomain = currentURL.toString().substring(11, 20);
                if (redirectDomain == "myappname") {
                  setState(() {
                    code = currentURL
                        .substring(currentURL.indexOf(RegExp('code=')) + 5);
                  });
                  getToken();
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
