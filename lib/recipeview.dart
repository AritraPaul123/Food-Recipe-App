

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Recipeview extends StatefulWidget {
  late String url;
  Recipeview(this.url);

  @override
  State<Recipeview> createState() => _RecipeviewState();
}

class _RecipeviewState extends State<Recipeview> {
  late String finalurl;

  @override
  void initState() {
    if(widget.url.toString().contains("http://")){
      finalurl=widget.url.toString().replaceAll("http://", "https://");
    }
    else{
      finalurl=widget.url;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recipe View Page"),
        ),
        body: Container(
            child: WebViewWidget(controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(finalurl)),
            )
        )

    );
  }
}


import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Recipeview extends StatefulWidget {
  late String url;
  Recipeview(this.url);

  @override
  State<Recipeview> createState() => _RecipeviewState();
}

class _RecipeviewState extends State<Recipeview> {
  late String finalurl;

  @override
  void initState() {
   if(widget.url.toString().contains("http://")){
     finalurl=widget.url.toString().replaceAll("http://", "https://");
   }
   else{
     finalurl=widget.url;
   }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recipe View Page"),
        ),
        body: Container(
            child: WebViewWidget(controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(finalurl)),
            )
        )

    );
  }
}
