import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Hivehelper.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final myController = TextEditingController();
  final List<Color> containerColors =
      []; // List to store colors for each container
  final List<Color> colorPattern = [
    Color(0xFFFD99FF),
    Color(0xFFFF9E9E),
    Color(0xFF91F48F),
    Color(0xFFFFF599),
    Color(0xFF9EFFFF),
    Color(0xFFB69CFF),
  ]; // Define the color pattern
  int colorIndex = 0; // To keep track of the current color index

  @override
  void initState() {
    HiveHelper.getnote();
    containerColors.addAll(List<Color>.generate(
        HiveHelper.noteslist.length,
        (index) => colorPattern[index %
            colorPattern.length])); // Initialize colors for existing notes
    super.initState();
  }

  void addColor() {
    setState(() {
      containerColors.add(colorPattern[colorIndex]);
      colorIndex = (colorIndex + 1) %
          colorPattern.length; // Move to the next color in the pattern
    });
  }

  void updateColor(int index) {
    setState(() {
      containerColors[index] = colorPattern[colorIndex];
      colorIndex = (colorIndex + 1) %
          colorPattern.length; // Move to the next color in the pattern
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Color(0xff252525),
      appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xff252525),
        onPressed: () async {
          myController.clear();
          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: Text("Enter your note"),
            content: TextFormField(
              controller: myController,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (myController.text.isNotEmpty) {
                    HiveHelper.add(myController.text);
                    Navigator.pop(context);
                    addColor(); // Add color for the new note
                    setState(() {});
                  }
                },
                child: Text("Add"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back"),
              )
            ],
          );

          // show the dialog
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
      ),
      body: ListView.builder(
        itemBuilder: (context, index) =>
            buildContainer(width, height, HiveHelper.noteslist[index], index),
        itemCount: HiveHelper.noteslist.length,
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget buildContainer(double width, double height, String text, int index) {
    return InkWell(
      onTap: () async {
        myController.text = HiveHelper.noteslist[index];
        AlertDialog alert = AlertDialog(
          title: Text("Enter your note"),
          content: TextFormField(
            controller: myController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (myController.text.isNotEmpty) {
                  HiveHelper.noteslist[index] = myController.text;
                  Navigator.pop(context);
                  updateColor(index); // Update the color for the edited note
                  setState(() {});
                }
              },
              child: Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back"),
            )
          ],
        );

        // show the dialog
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            width: width,
            height: height * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: containerColors[
                  index], // Use the stored color for the container
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Nunito',
                  color: Colors.black,
                ),
              ),
            ),
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Icon(
                CupertinoIcons.delete,
                color: Colors.red,
              ),
            ),
            onTap: () {
              HiveHelper.remove(index);
              containerColors
                  .removeAt(index); // Remove the color for the deleted note
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Color(0XFF252525),
      title: Text(
        "Notes",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 43,
          color: Colors.white,
          fontFamily: 'Nunito',
        ),
      ),
      actions: [
        InkWell(
          child: Icon(
            CupertinoIcons.delete,
            color: Colors.white,
          ),
          onTap: () {
            HiveHelper.clearList();
            containerColors.clear(); // Clear all colors
            setState(() {});
          },
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
