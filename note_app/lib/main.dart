import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Model cho ghi chú
class Note {
  String content;
  Note({required this.content});
}

// Provider quản lý danh sách ghi chú
class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(String content) {
    _notes.add(Note(content: content));
    notifyListeners();
  }

  void updateNote(int index, String newContent) {
    _notes[index].content = newContent;
    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const NoteHomePage(),
    );
  }
}

// Màn hình chính hiển thị danh sách ghi chú
class NoteHomePage extends StatelessWidget {
  const NoteHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note App (Provider)'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: noteProvider.notes.length,
        itemBuilder: (context, index) {
          final note = noteProvider.notes[index];
          return ListTile(
            title: Text(note.content),
            onTap: () {
              // Chỉnh sửa ghi chú
              showDialog(
                context: context,
                builder: (context) {
                  final controller = TextEditingController(text: note.content);
                  return AlertDialog(
                    title: const Text('Chỉnh sửa ghi chú'),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(hintText: 'Nội dung mới'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          noteProvider.updateNote(index, controller.text);
                          Navigator.pop(context);
                        },
                        child: const Text('Lưu'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy'),
                      ),
                    ],
                  );
                },
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => noteProvider.deleteNote(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Thêm ghi chú mới
          showDialog(
            context: context,
            builder: (context) {
              final controller = TextEditingController();
              return AlertDialog(
                title: const Text('Thêm ghi chú mới'),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Nhập nội dung ghi chú'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        noteProvider.addNote(controller.text.trim());
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Thêm'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
