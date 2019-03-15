import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

Future main() async {
  runApp(new WebViewTest());
}

class WebViewTest extends StatefulWidget {
  @override
  _WebViewTestState createState() => new _WebViewTestState();
}

class _WebViewTestState extends State<WebViewTest> {

  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Inline WebView example app'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text("CURRENT URL\n${ (url.length > 50) ? url.substring(0, 50) + "..." : url }"),
              ),
              (progress != 1.0) ? LinearProgressIndicator(value: progress) : null,
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                  ),
                  child: InAppWebView(
                    //initialUrl: "https://flutter.io/",
                    initialUrl: "https://app.meetnotes.co/m/59a915a5-a63a-4a96-9a38-a845eb560b2a/",
                    initialHeaders: {
                      

                    },
                    initialOptions: {

                    },
                    onWebViewCreated: (InAppWebViewController controller) {
                      url = 'https://app.meetnotes.co/m/59a915a5-a63a-4a96-9a38-a845eb560b2a/';
                      CookieManager.setCookie(url, 'sessionid', 'sm9yh597cptfrkx4h3hl2ou4wzopc6eo;');
                      webView = controller;
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {
                      print("started $url");
                      setState(() {
                        this.url = url;
                      });
                    },
                    onProgressChanged: (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress/100;
                      });
                    },
                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Icon(Icons.arrow_back),
                    onPressed: () {
                      if (webView != null) {
                        webView.goBack();
                      }
                    },
                  ),
                  RaisedButton(
                    child: Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (webView != null) {
                        webView.goForward();
                      }
                    },
                  ),
                  RaisedButton(
                    child: Icon(Icons.refresh),
                    onPressed: () {
                      if (webView != null) {
                        webView.reload();
                      }
                    },
                  ),
                ],
              ),
            ].where((Object o) => o != null).toList(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              title: Text('Item 2'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Item 3')
            )
          ],
        ),
      ),
    );
  }
}