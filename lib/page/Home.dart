import 'dart:typed_data';
import 'dart:html' as html;
import 'package:ddl_er/API/getApiData.dart';
import 'package:ddl_er/tree.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/sql.dart';
import 'package:ddl_er/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = CodeController(
    text: '/*enter your DDL*/', // Initial code
    language: sql,
  );
  Uint8List? _downloadedImageNoLable;
  Uint8List? _downloadedImageLable;
  Map<String, dynamic>? JSONData;
  bool checkedValue = false;
  bool loading = false;
  bool isAPIcalled = false;
  GetAPIData getAPIData = GetAPIData();
  Future<void> getERFromAPI(
      {required String query,
      required String type,
      required String result}) async {
    try {
      setState(() {
        loading = true;
        JSONData = null;
      });
      Future.delayed(Duration(seconds: 1));
      final String apiLinkwolable =
          "$apiERLink/ER?type=$type&lable=false&result=$result&query=$query";
      final String apiLinkwlable =
          "$apiERLink/ER?type=$type&lable=true&result=$result&query=$query";
      final String jsonUrl =
          "$apiERLink/ER?type=$type&lable=true&result=json&query=$query";

      _downloadedImageNoLable =
          await getAPIData.downloadRAWimage(apiLinkwolable);
      _downloadedImageLable = await getAPIData.downloadRAWimage(apiLinkwlable);
      JSONData = await getAPIData.downloadJSON(jsonUrl);

      isAPIcalled = true;
      loading = false;
      setState(() {});
    } catch (e) {
      JSONData = null;
    }
  }

  void saveImage(Uint8List imageData, String filename) {
    final blob = html.Blob([imageData]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    // ignore: unused_local_variable
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 8,
        bottom: 4,
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.white,
                    child: Card(
                      color: Colors.white,
                      elevation: 6,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 40,
                              width: width / 2,
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width / 2.63,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'SQL to ER Diagram',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          children: [
                                            FilledButton(
                                              style: FilledButton.styleFrom(
                                                textStyle: const TextStyle(
                                                    fontSize: 15),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 109, 139, 221),
                                              ),
                                              onPressed: () {
                                                getERFromAPI(
                                                    query: controller.text
                                                        .replaceAll("\n", " "),
                                                    result: 'png',
                                                    type: 'ER');
                                              },
                                              child: const Text(
                                                'Visualize',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            loading == true
                                                ? const SizedBox(
                                                    height: 10.0,
                                                    width: 10.0,
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  )
                                                : const Text('')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            height: height / 2.15,
                            child: CodeTheme(
                              data: CodeThemeData(styles: monokaiSublimeTheme),
                              child: SingleChildScrollView(
                                child: CodeField(
                                  decoration: const BoxDecoration(
                                    // borderRadius: BorderRadius.only(
                                    //     topLeft: Radius.circular(12),
                                    //     topRight: Radius.circular(12)),
                                    color: Colors.white,
                                  ),
                                  minLines: 13,
                                  controller: controller,
                                  gutterStyle: const GutterStyle(
                                    background: Colors.white,
                                    showFoldingHandles: true,
                                    margin: 0,
                                    textStyle: TextStyle(
                                      fontSize: 2,
                                      inherit: true,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_downloadedImageNoLable != null)
                            Container(
                              color: Colors.white,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Divider(
                                  color: Color.fromARGB(36, 71, 71, 71),
                                ),
                              ),
                            ),
                          Column(
                            children: [
                              Container(
                                  color: Colors.white,
                                  height: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: _downloadedImageNoLable != null
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Simple Raw Image',
                                                style: TextStyle(fontSize: 11),
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Lable',
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                    child: Checkbox(
                                                      value: checkedValue,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          checkedValue =
                                                              newValue!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      saveImage(
                                                          checkedValue
                                                              ? _downloadedImageLable!
                                                              : _downloadedImageNoLable!,
                                                          'ER.png');
                                                    },
                                                    child: Text('Download'),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        : const SizedBox(
                                            width: double.infinity,
                                          ),
                                  )),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12)),
                                  color: Colors.white,
                                ),
                                height: height / 2.66,
                                child: _downloadedImageNoLable != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.memory(
                                          checkedValue
                                              ? _downloadedImageLable!
                                              : _downloadedImageNoLable!,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    : Text(''),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: height - 30,
                      child: JSONData != null &&
                              JSONData != {} &&
                              JSONData!.isNotEmpty
                          ? TreeViewPage(JSONData: JSONData)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/1475.gif",
                                  height: 115.0,
                                  width: 115.0,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Enter Your DDL',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
