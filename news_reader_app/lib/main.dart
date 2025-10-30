import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Article {
  final String title;
  final String url;
  final String imageUrl;
  final String description;

  Article({
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.description,  
    });


  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      description: json['description'] ?? 'No Description',
    );
  }
}





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<Article>> fetchNews() async {
  const apiKey ='f18a9c5b9ff14f9f891a202ac8b6153e';
  final url = 'https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=$apiKey';
  final response = await http.get(Uri.parse(url));
  if(response.statusCode == 200){
    final data = json.decode(response.body);
    final List articles = data['articles'];
    return articles.map((json) => Article.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');// Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
  }

}
  
  

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Article>>(
        future: fetchNews(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('No articles found'));
          } else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index){
                final article = articles[index];
                return ListTile(
                  leading: article.imageUrl.isNotEmpty
                    ? Image.network(article.imageUrl, width: 100, fit: BoxFit.cover)
                    : null,
                  title: Text(article.title),
                  subtitle: Text(article.description),
                  onTap: () {
                    // Handle article tap, e.g., open in browser
                  },
                );
              },
            );
          }
        },
      ),
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
