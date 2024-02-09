import 'dart:async';
import 'dart:convert';
import 'package:demo/fonts.dart';
import 'package:demo/tajweed_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RenderHtml extends StatefulWidget {
  final String html;

  RenderHtml({
    required this.html,
  });

  @override
  State<RenderHtml> createState() => _RenderHtmlState();
}

class _RenderHtmlState extends State<RenderHtml> {
  late String htmlContent;
  late WebViewController wbController;
  double height = 100.0;

  @override
  void initState() {
    super.initState();
    htmlContent = widget.html;

    var htm = """
          <!DOCTYPE html>
            <html lang="en">
              <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <style>

                  @font-face { font-family: "fontForText"; src: url(data:font/truetype;charset=utf-8;base64,${fonts['noorehuda']}) format("truetype"); }

                  @font-face { font-family: "fontForWaqph"; src: url(data:font/truetype;charset=utf-8;base64,${fonts['lateef']}) format("truetype"); }
            
                  body {
                    font-size: 30px;
                    direction: rtl;
                    display: flex;
                    flex-wrap: wrap;
                    font-family: "fontForText";
                    padding-bottom: 20px;
                    color: black;
                  }

                  div.waqph {
                    font-family: "fontForWaqph";
                  }

                  .active {
                    color: green;
                  }

                  $tajweedStyle

                </style>
              </head>
              <body>
              $htmlContent
              <script>
                  function highlightWord(s, v, w) {
                    const activeWord = document.getElementsByClassName("active");
                    if (activeWord.length > 0) activeWord[0].classList.remove("active");

                    const wordClass = s + "_" + v + "_" + w;

                    const word = document.getElementsByClassName(wordClass);
                    word[0].classList.add("active");
                  }
              </script>
              </body>
            </html>
          """;

    wbController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            var x = await wbController.runJavaScriptReturningResult(
                "document.documentElement.scrollHeight");
            double? y = double.tryParse(x.toString());
            setState(() {
              height = y!;
            });
          },
        ),
      )
      ..loadHtmlString(htm);
  }

  Future<String> fontFileToBase64(String fontFilePath) async {
    // Read font file as byte data
    ByteData fontData = await rootBundle.load(fontFilePath);
    List<int> fontBytes = fontData.buffer.asUint8List();

    // Encode font bytes to base64
    String base64String = base64Encode(fontBytes);

    return base64String;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // If the widget.html changes after initState, you can update htmlContent here
    htmlContent = widget.html;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: WebViewWidget(
        controller: wbController,
      ),
    );
  }
}
