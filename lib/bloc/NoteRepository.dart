import 'package:banao_notes_app/services/database.dart';
import '../model/myNoteModel.dart';

class NotesRepository {
  final NotesDatabase _dbHelper = NotesDatabase();

  Future<List<Note>> getAllNotes() async => await _dbHelper.readAllNotes();
  Future<void> closeDB() async => await _dbHelper.closeDB();
  Future<Note?> getNoteById(int id) async => await _dbHelper.readOneNote(id);
  Future<Note?> createNote(Note note) async => await _dbHelper.InsertEntry(note);
  Future<bool> deleteNoteById(int id) async => await _dbHelper.deleteNotes(id);
  Future<bool> updateNoteById(Note note) async => await _dbHelper.updateNote(note);
}