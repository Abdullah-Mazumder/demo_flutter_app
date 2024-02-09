import 'dart:async';
import 'dart:convert';

import 'package:demo/render_html.dart';
import 'package:demo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Surah extends StatefulWidget {
  const Surah({super.key});

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

    // Timer(Duration(seconds: 10), () {
    // itemScrollController.scrollTo(
    //     index: 100,
    //     duration: Duration(milliseconds: 500),
    //     curve: Curves.ease);

    // itemScrollController.jumpTo(index: 100);
    // });
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

                      return RenderHtml(html: htmlVerse);
                    },
                    itemCount: dataList.length,
                  ),
                ),
              ],
            ),
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
