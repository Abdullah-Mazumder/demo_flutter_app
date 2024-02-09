import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Surah extends StatefulWidget {
  const Surah({Key? key}) : super(key: key);

  @override
  State<Surah> createState() => _SurahState();
}

class _SurahState extends State<Surah> {
  late List<AyahModel> dataList;
  var isLoading = true;
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/html.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    setState(() {
      dataList = jsonList.map((json) => AyahModel.fromJson(json)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Render Html",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Render something before the ListView.builder
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomeScreen(),
                            ),
                          );
                        },
                        child: const Text("Navigate"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ScrollablePositionedList.builder(
                    itemScrollController: itemScrollController,
                    itemBuilder: (context, index) {
                      AyahModel ayah = dataList[index];
                      var htmlVerse = ayah.verseHtml;

                      return WebviewScaffold(
                        url: 'about:blank',
                        withZoom: false,
                        withLocalStorage: true,
                        hidden: true,
                        initialChild: Container(
                          color: Colors.white,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        appBar: AppBar(
                          title: Text("Verse ${ayah.verseId}"),
                        ),
                        initialChild: Container(
                          color: Colors.white,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        javascriptChannels: <JavascriptChannel>{
                          _toasterJavascriptChannel(context),
                        },
                        userAgent: 'Flutter',
                        withJavascript: true,
                        withLocalUrl: true,
                        allowFileURLs: true,
                        withZoom: false,
                        hidden: true,
                        initialChild: Container(
                          color: Colors.white,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        bottomNavigationBar: BottomAppBar(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  _webViewController.reload();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  _webViewController.goForward();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: dataList.length,
                  ),
                ),
              ],
            ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      },
    );
  }
}

class AyahModel {
  final int surahId;
  final int verseId;
  final String verseHtml;

  AyahModel({
    required this.surahId,
    required this.verseId,
    required this.verseHtml,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      surahId: json['surahId'],
      verseId: json['verseId'],
      verseHtml: json['verseHtml'],
    );
  }
}
