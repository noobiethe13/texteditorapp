import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class TextModel {
  String text;
  Color textColor;
  double fontSize;
  String fontFamily;
  Offset position;

  TextModel({
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.fontFamily,
    required this.position,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TextModel> textList = [];

  Future<void> openDialog() async {
    final TextEditingController textController = TextEditingController();

    final newText = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add Text',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.grey[300],
              labelText: "Type Something",
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            controller: textController,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, textController.text.trim());
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (newText != null && newText.isNotEmpty) {
      setState(() {
        textList.add(TextModel(
          text: newText,
          textColor: Colors.white,
          fontSize: 24.0,
          fontFamily:'Lato',
          position: Offset(
            MediaQuery.of(context).size.width / 2 - 100,
            MediaQuery.of(context).size.height / 2 - 100,
          ),
        ));
      });
    }
  }

  Future<void> openOptions(TextModel textModel) async {
    double? newSize;
    String? newFontFamily;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Text'),
                onTap: () {
                  setState(() {
                    textList.remove(textModel);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Change Color'),
                onTap: () async {
                  Color? pickedColor = await showDialog<Color>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a Color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: textModel.textColor,
                            onColorChanged: (Color color) {
                              textModel.textColor = color;
                            },
                            labelTypes: const [],
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, textModel.textColor);
                            },
                            child: const Text('Select'),
                          ),
                        ],
                      );
                    },
                  );
                  if (pickedColor != null) {
                    setState(() {
                      textModel.textColor = pickedColor;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.format_size),
                title: const Text('Change Font Size'),
                onTap: () async {
                  newSize = await showDialog<double>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Enter Font Size'),
                        content: TextField(
                          decoration: InputDecoration(
                            floatingLabelBehavior:
                            FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Colors.grey[300],
                            labelText: "Type Something",
                            labelStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (String value) {
                            newSize = double.tryParse(value);
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, newSize);
                            },
                            child: const Text('Apply'),
                          ),
                        ],
                      );
                    },
                  );
                  if (newSize != null) {
                    setState(() {
                      textModel.fontSize = newSize!;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.font_download),
                title: const Text('Change Font Family'),
                onTap: () async {
                  newFontFamily = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Font Family'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (String fontFamily in GoogleFonts.asMap().keys)
                                ListTile(
                                  title: Text(fontFamily),
                                  onTap: () {
                                    Navigator.pop(context, fontFamily);
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  if (newFontFamily != null) {
                    setState(() {
                      textModel.fontFamily = newFontFamily!;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: openDialog,
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 40, color: Colors.black),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_Image.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          for (TextModel textModel in textList)
            Positioned(
              left: textModel.position.dx,
              top: textModel.position.dy,
              child: GestureDetector(
                onTap: () => openOptions(textModel),
                onLongPress: () {
                  // Start dragging
                  setState(() {});
                },
                child: Draggable(
                  feedback: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textModel.text,
                      style: GoogleFonts.getFont(
                        textModel.fontFamily,
                        textStyle: TextStyle(
                          color: textModel.textColor,
                          fontSize: textModel.fontSize,
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(),
                  onDragEnd: (dragDetails) {
                    // Update position after dragging
                    setState(() {
                      textModel.position = dragDetails.offset;
                    });
                  },
                  data: textModel.text,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textModel.text,
                      style: GoogleFonts.getFont(
                        textModel.fontFamily,
                        textStyle: TextStyle(
                          color: textModel.textColor,
                          fontSize: textModel.fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}