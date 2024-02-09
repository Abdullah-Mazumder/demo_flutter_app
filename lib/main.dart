import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:demo/surah.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: Surah(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  late List<AyahModel> dataList;
  var isLoading = true;
  var textSize = 25;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future _scrollToCounter(int i) async {
    itemScrollController.scrollTo(
        index: i, duration: Duration(milliseconds: 500), curve: Curves.ease);

    // itemScrollController.jumpTo(index: i);
  }

  Future<void> loadJsonData() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/db.json');
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
        title: const Text("Home"),
        backgroundColor: Colors.pink,
      ),
      body: (isLoading == true)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Render something before the ListView.builder
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Slider(
                        value: textSize.toDouble(),
                        min: 20,
                        max: 60,
                        label: textSize.toString(),
                        onChanged: (newValue) {
                          setState(() {
                            textSize = newValue.toInt();
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Create an instance of the Random class
                          Random random = Random();

                          // Generate a random integer between 1 and 286
                          int randomInteger = random.nextInt(286) + 1;

                          print(randomInteger);

                          _scrollToCounter(randomInteger);
                        },
                        child: Text("Jump"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ScrollablePositionedList.builder(
                    itemScrollController: itemScrollController,
                    scrollOffsetController: scrollOffsetController,
                    itemPositionsListener: itemPositionsListener,
                    scrollOffsetListener: scrollOffsetListener,
                    itemBuilder: (context, index) {
                      AyahModel ayah = dataList[index];

                      return Container(
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              ayah.arabicText,
                              style: TextStyle(
                                  fontSize: textSize.toDouble(),
                                  fontFamily: "noorehira"),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              ayah.banglaAhbayan,
                              style: const TextStyle(fontFamily: 'regularFont'),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 286,
                  ),
                ),
              ],
            ),
    );
  }
}

class AyahModel {
  final int id;
  final String arabicText;
  final String englishText;
  final int page;
  final bool isSajdahAyat;
  final String audio;
  final String colorText;
  final int juz;
  final int ruku;
  final int manzil;
  final String banglaAhbayan;
  final String banglaBayan;
  final String banglaMkhan;
  final String banglaMujibur;
  final String banglaTaisirul;

  AyahModel({
    required this.id,
    required this.arabicText,
    required this.englishText,
    required this.page,
    required this.isSajdahAyat,
    required this.audio,
    required this.colorText,
    required this.juz,
    required this.ruku,
    required this.manzil,
    required this.banglaAhbayan,
    required this.banglaBayan,
    required this.banglaMkhan,
    required this.banglaMujibur,
    required this.banglaTaisirul,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      id: json['id'],
      arabicText: json['arabic_text'],
      englishText: json['english_text'],
      page: json['page'],
      isSajdahAyat: json['is_sajdah_ayat'],
      audio: json['audio'],
      colorText: json['colorText'],
      juz: json['juz'],
      ruku: json['ruku'],
      manzil: json['manzil'],
      banglaAhbayan: json['bangla_ahbayan'],
      banglaBayan: json['bangla_bayan'],
      banglaMkhan: json['bangla_mkhan'],
      banglaMujibur: json['bangla_mujibur'],
      banglaTaisirul: json['bangla_taisirul'],
    );
  }
}
