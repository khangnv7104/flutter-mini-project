
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const   MaterialApp(home: TodoPage()));
}



class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<String> tasks = [];
  
    TextEditingController controller = TextEditingController();

    @override
    void initState(){
      super.initState();
      loadTasks();
    }

    Future<void> loadTasks() async{
      final prefs= await SharedPreferences.getInstance();
      final data = prefs.getString('tasks');
      if(data != null){
        setState(() {
          tasks = List<String>.from(json.decode(data) );
        });
      }
    }

    Future<void> saveTasks() async{
      final pref = await SharedPreferences.getInstance();
      await pref.setString('tasks', json.encode(tasks));
    }
    
    void addTask(String task){
      setState(() {
        tasks.add(task);
      });
      saveTasks();
      controller.clear();
    }

    void removeTask(int index){
      setState(() {
        tasks.removeAt(index);
      });
      saveTasks();
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Todo App')),
        body: Column(
          children: [
            Padding (padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                  Expanded(child:   TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'add new task',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: (){
                    if(controller.text.trim().isNotEmpty){
                      addTask(controller.text.trim());
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(tasks[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeTask(index),
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


  


 
