import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:graphview/GraphView.dart';

class TreeViewPage extends StatefulWidget {
  final Map<String, dynamic>? JSONData;
  const TreeViewPage({
    super.key,
    required this.JSONData,
  });

  @override
  _TreeViewPageState createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  bool ShowColumn = false;
  bool ShowFk = true;
  final Graph graph = Graph();
  final _controller = TextEditingController(text: 'Left To Right');
  SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..bendPointShape = CurvedBendPointShape(curveLength: 20);
  GlobalKey globalKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    createTree();
    builder
      ..nodeSeparation = (40)
      ..levelSeparation = (50)
      ..orientation = (3)
      ..coordinateAssignment = CoordinateAssignment.DownLeft;
  }

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      saveImage(pngBytes, 'ER_Image.png');
    } catch (e) {
      print(e);
    }
  }

  String OrgText = 'Left TO Right';
  List Org = [
    'Top To Bottom',
    'Bottom To Top',
    'Left To Right',
    'Right To Left',
  ];
  createTree() {
    final Map<String, dynamic>? data = widget.JSONData;

    data!.forEach(
      (node, table) {
        if ((table['foreign_keys_len'] == 0) && data.length == 1) {
          graph.addNode(Node.Id(node));
        } else if ((table['foreign_keys_len'] == 0) && data.length > 1) {
          graph.addNode(Node.Id(node));
        } else {
          table['foreign_keys'].forEach((dep, foreignKey) {
            graph.addEdge(
              Node.Id(dep),
              Node.Id(node),
              paint: Paint()
                ..color = Colors.black
                ..strokeWidth = 2.0,
            );
          });
        }
      },
    );
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                child: TextFormField(
                  initialValue: builder.nodeSeparation.toString(),
                  decoration:
                      const InputDecoration(labelText: 'Table Separation'),
                  onChanged: (text) {
                    builder.nodeSeparation = int.tryParse(text) ?? 30;
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 110,
                child: TextFormField(
                  initialValue: builder.levelSeparation.toString(),
                  decoration:
                      const InputDecoration(labelText: 'Level Separation'),
                  onChanged: (text) {
                    builder.levelSeparation = int.tryParse(text) ?? 50;
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 140,
                child: TextFormField(
                  readOnly: true,
                  controller: _controller,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Orientation',
                  ),
                  onChanged: (text) {
                    builder.orientation = int.tryParse(text) ?? 3;
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: 220,
                  child: Row(
                    children: [
                      const Text(
                        'Alignment',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      DropdownButton<CoordinateAssignment>(
                        value: builder.coordinateAssignment,
                        items: CoordinateAssignment.values
                            .map((coordinateAssignment) {
                          return DropdownMenuItem<CoordinateAssignment>(
                            value: coordinateAssignment,
                            child: Text(coordinateAssignment.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            builder.coordinateAssignment = value!;
                          });
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
        Expanded(
          child: InteractiveViewer(
              constrained: false,
              boundaryMargin: EdgeInsets.all(100),
              minScale: 0.0001,
              maxScale: 10.6,
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  color: Colors.white,
                  child: GraphView(
                    graph: graph,
                    algorithm: SugiyamaAlgorithm(builder),
                    paint: Paint()
                      ..color = Colors.green
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      // I can decide what widget should be shown here based on the id
                      var a = node.key!.value as String?;
                      return rectangleWidget(a);
                    },
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 20),
          child: Align(
              alignment: Alignment.bottomRight,
              child: Card(
                elevation: 8,
                color: Colors.white,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white, // Change color on focus
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  height: 50,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide.none,
                          ),
                        ),
                        onPressed: () {
                          if (builder.orientation < 3) {
                            builder.orientation = builder.orientation + 1;
                          } else {
                            builder.orientation = 1;
                          }
                          _controller.text = Org[builder.orientation];
                          setState(() {});
                        },
                        child: const Text('Orientation'),
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide.none,
                          ),
                        ),
                        onPressed: () {
                          ShowColumn = !ShowColumn;
                          setState(() {});
                        },
                        child: const Text('Columns'),
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide.none,
                          ),
                        ),
                        onPressed: () {
                          ShowFk = !ShowFk;
                          setState(() {});
                        },
                        child: const Text('Keys'),
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide.none,
                          ),
                        ),
                        onPressed: () {
                          _capturePng();
                        },
                        child: const Text('Download'),
                      ),
                      const SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Random r = Random();

// Function to extract keys from a Map
  List<String> extractKeys(Map<String, dynamic> map) {
    List<String> keys = [];
    map.forEach((key, value) {
      keys.add(key);
      if (value is Map<String, dynamic>) {
        keys.addAll(extractKeys(value));
      }
    });
    return keys;
  }

  Widget rectangleWidget(String? a) {
    List fk = [];
    List columns = [];
    List pk = [];
    List key = [];
    if (a != null && widget.JSONData![a] != null) {
      final tableData = widget.JSONData![a];

      columns = extractKeys(tableData['columns']);
      pk = tableData['PrimaryKey'];

      final foreign_keys = tableData['foreign_keys'];

      List<String> keys = extractKeys(foreign_keys);
      fk = [];

      for (int i = 0; i < keys.length - 1; i = i + 5) {
        String right_table = keys.isNotEmpty ? keys[i] : '';
        if (right_table != '') {
          fk = fk + foreign_keys[right_table]['left_table_column'];
        }
      }

      key = fk + pk;
      key = key.toSet().toList();
    }

    return Container(
        height: ShowColumn == true
            ? columns.length < 3
                ? 100
                : columns.length * 45
            : 100,
        width: 200,
        // padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          boxShadow: [
            BoxShadow(color: Colors.transparent, spreadRadius: 1),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(color: Colors.blue[200]!, spreadRadius: 1),
                ],
              ),
              width: double.infinity,
              height: !(ShowFk || ShowColumn) ? 100 : 30,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, top: 4),
                  child: Text(
                    a!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            if (ShowColumn == true)
              Container(
                padding: const EdgeInsets.only(left: 6, top: 4),
                decoration: myBoxDecoration(),
                child: SizedBox(
                  height: columns.length * 32,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: columns.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        bool isfk = fk.contains(columns[i]);
                        bool ispk = pk.contains(columns[i]);
                        return Row(
                          children: [
                            if (ispk)
                              Container(
                                width: 6.0, // The width of the circle
                                height: 6.0, // The height of the circle
                                decoration: BoxDecoration(
                                  color: Colors
                                      .green[300], // The color of the circle
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (ispk)
                              const SizedBox(
                                width: 5,
                              ),
                            if (isfk)
                              Container(
                                width: 6.0, // The width of the circle
                                height: 6.0, // The height of the circle
                                decoration: const BoxDecoration(
                                  color: Colors.blue, // The color of the circle
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (isfk || ispk)
                              const SizedBox(
                                width: 5,
                              ),
                            if (!ispk && !isfk)
                              const SizedBox(
                                width: 13,
                              ),
                            Text(columns[i]),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            if (ShowFk && ShowColumn == false)
              Container(
                padding: const EdgeInsets.only(left: 6, top: 4),
                decoration: myBoxDecoration(),
                height: 70,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: key.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, i) {
                    return Row(
                      children: [
                        if (pk.contains(key[i]))
                          Container(
                            width: 6.0, // The width of the circle
                            height: 6.0, // The height of the circle
                            decoration: BoxDecoration(
                              color:
                                  Colors.green[300], // The color of the circle
                              shape: BoxShape.circle,
                            ),
                          ),
                        const SizedBox(
                          width: 3,
                        ),
                        if (fk.contains(key[i]))
                          Container(
                            width: 6.0, // The width of the circle
                            height: 6.0, // The height of the circle
                            decoration: const BoxDecoration(
                              color: Colors.blue, // The color of the circle
                              shape: BoxShape.circle,
                            ),
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(key[i]),
                      ],
                    );
                  },
                ),
              )
          ],
        ));
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[50],
      border: Border.all(
        color: Colors.grey[300]!,
      ),
    );
  }
}
