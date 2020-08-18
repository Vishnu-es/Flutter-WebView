import 'dart:async';
import 'dart:convert';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  String htmlFilePath = 'assets/error.html';

  WebViewController wvc;
  loadLocalHTML() async {
    String fileHtmlContents = await rootBundle.loadString(htmlFilePath);
    wvc.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: WebView(
            initialUrl: "https://www.google.com/",
            onWebResourceError: (WebResourceError webviewerrr) {
              print(
                  "Handle your Error Page here"); // =====> This gets printed whenever there is no internet.
              loadLocalHTML(); //======> This loads Local HTML file.
            },
            onWebViewCreated: ((WebViewController webViewController) {
              _completer.complete(webViewController);
              wvc = webViewController;
              webViewController.clearCache();
              final cookieManager = CookieManager();
              cookieManager.clearCookies();
            }),
            javascriptMode: JavascriptMode.unrestricted),
      ),
    );
  }
}
