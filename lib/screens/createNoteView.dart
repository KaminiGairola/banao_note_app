import 'package:banao_notes_app/services/database.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
import 'home.dart';
import '../model/myNoteModel.dart';

class createNoteView extends StatefulWidget {
  const createNoteView({Key? key}) : super(key: key);

  @override
  State<createNoteView> createState() => _createNoteViewState();
}

class _createNoteViewState extends State<createNoteView> {
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: bgColor,
        elevation: 0.0,
        actions: [
          IconButton(
            splashRadius: 17,
            onPressed: () async {
              await NotesDatabase.instance.InsertEntry(Note(
                  title: title.text,
                  content: content.text,
                  pin: false,
                  isArchive: false,
                  createdTime: DateTime.now()));
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => home()));
            },
            icon: Icon(
              Icons.save_outlined,
              color: white,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            TextField(
              cursorColor: white,
              controller: title,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.withOpacity(0.8))),
            ),
            Container(
              height: 300,
              child: TextField(
                controller: content,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                cursorColor: white,
                style: TextStyle(fontSize: 17, color: Colors.white),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Note",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.8))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
