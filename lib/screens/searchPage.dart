import 'package:banao_notes_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../colors.dart';
import '../model/myNoteModel.dart';
import 'noteView.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {

  List<int> searchResultIds = [];
  List<Note?> searchResultNotes = [];

  bool isLoading = false;

  void searchResults(String query) async {
    searchResultNotes.clear();
    setState(() {
      isLoading = true;
    });

    final resultIds = await NotesDatabase.instance.getNoteString(
        query); // [1,2,3,4,5]
    List<Note?> searchResultNotesLocal = []; //[note 1, note 2]
    resultIds.forEach((element) async {
      final searchNote = await NotesDatabase.instance.readOneNote(element);

      searchResultNotesLocal.add(searchNote);
      setState(() {
        searchResultNotes.add(searchNote);
      });
    });
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: white.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_outlined, color: white,),
                    ),
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Search your notes",
                          hintStyle: TextStyle(
                            color: white.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            searchResults(value.toLowerCase());
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Center(
                child: CircularProgressIndicator(color: Colors.white,),
              )
                  : noteSectionAll(),
            ],
          ),
        ),
      ),
    );
  }

  Widget noteSectionAll() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "SEARCH RESULTS",
              style: TextStyle(
                color: white.withOpacity(0.5),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          MasonryGridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: searchResultNotes.length,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => noteView(note: searchResultNotes[index]!)),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: white.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        searchResultNotes[index]!.title,
                        style: TextStyle(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        searchResultNotes[index]!.content.length > 250
                            ? "${searchResultNotes[index]!.content.substring(0, 250)}..."
                            : searchResultNotes[index]!.content,
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
