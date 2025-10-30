import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Widget chính của app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI Clone',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const ChatPage(),
    );
  }
}

// Danh sách tin nhắn mẫu
final List<Map<String, dynamic>> messages = [
  {
    'text': 'Chào bạn!',
    'isMe': false,
    'time': '09:00',
    'avatar': 'https://i.pravatar.cc/40?img=1',
  },
  {
    'text': 'Chào bạn, bạn khỏe không?',
    'isMe': true,
    'time': '09:01',
    'avatar': 'https://i.pravatar.cc/40?img=2',
  },
  {
    'text': 'Mình khỏe, cảm ơn bạn!',
    'isMe': false,
    'time': '09:02',
    'avatar': 'https://i.pravatar.cc/40?img=1',
  },
  {
    'text': 'Bạn học Flutter chưa?',
    'isMe': true,
    'time': '09:03',
    'avatar': 'https://i.pravatar.cc/40?img=2',
  },
  {
    'text': 'Mình đang học, rất thú vị!',
    'isMe': false,
    'time': '09:04',
    'avatar': 'https://i.pravatar.cc/40?img=1',
  },
];

// Màn hình chat chính
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat UI Clone'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ListView hiển thị danh sách tin nhắn, có thể cuộn
          Expanded(
            child: ListView.builder(
              reverse: true, // Tin nhắn mới ở dưới
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                return MessageBubble(
                  text: msg['text'],
                  isMe: msg['isMe'],
                  time: msg['time'],
                  avatar: msg['avatar'],
                );
              },
            ),
          ),
          // Khu vực nhập tin nhắn (chỉ giao diện, không gửi thật)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {}, // Chỉ giao diện, không gửi thật
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget hiển thị bong bóng tin nhắn
class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final String avatar;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        // Avatar bên trái nếu là người khác
        if (!isMe)
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(avatar),
          ),
        // Bong bóng tin nhắn
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 220),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue[200] : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(text, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text(time, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ),
        // Avatar bên phải nếu là mình
        if (isMe)
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(avatar),
          ),
      ],
    );
  }
}
