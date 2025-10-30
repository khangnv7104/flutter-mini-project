import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleDarkMode(){
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Profile',
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyProfileApp(
        title: 'Personal Profile',
        isDarkMode: isDarkMode,
        toggleDarkMode: toggleDarkMode,
        ),
    );
  }
}

class MyProfileApp extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleDarkMode;
  final String title;

  const MyProfileApp({
    super.key, 
    required this.title,
    required this.isDarkMode,
    required this.toggleDarkMode,
    });
    
  @override
  State<MyProfileApp> createState() => _MyProfileAppState();
}

class _MyProfileAppState extends State<MyProfileApp> {
    
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleDarkMode,
            tooltip: "Toggle Dark Mode",
            ),

        ],
        
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://www.shutterstock.com/image-vector/human-profile-avatar-blue-icon-600w-2111144018.jpg'),
              ),
              SizedBox(height: 16),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Tên'),
                      subtitle: Text('Nguyễn Vinh Khang'),
                    ),
                    ListTile(
                      leading: Icon(Icons.cake),
                      title: Text('Tuổi'),
                      subtitle: Text('21'),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Gmail'),
                      subtitle: Text('khang170701712004@gmail.com'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Số điện thoại'),
                      subtitle: Text('0934722697'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: ListTile(
                  leading: Icon(Icons.code),
                  title: Text('Kỹ năng'),
                  subtitle: Text('Flutter, Dart, React Native, Firebase, Git'),
                ),
              ),
              SizedBox(height: 16),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.facebook),
                      title: Text('Facebook'),
                      subtitle: Text('fb.com/khangnguyen'),
                    ),
                    ListTile(
                      leading: Icon(Icons.web),
                      title: Text('Website'),
                      subtitle: Text('khangnguyen.dev'),
                    ),
                    ListTile(
                      leading: Icon(Icons.code),
                      title: Text('GitHub'),
                      subtitle: Text('github.com/khangnv7104'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}
