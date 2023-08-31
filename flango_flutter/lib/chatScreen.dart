import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// ChatProvider to manage chat state
class ChatProvider with ChangeNotifier {
  final WebSocketChannel channel;
  List<Widget> _messages = [];

  ChatProvider(this.channel) {
    channel.stream.listen((event) {
      print("new event: $event");
      final Map<String, dynamic> messageMap = jsonDecode(event);
      final String message = messageMap['message'];

      addMessage(message, true);
    });
  }

  List<Widget> get messages => _messages;

  void addMessage(String message, bool received) {
    _messages.add(
      Text(
        message,
        textAlign: received ? TextAlign.left : TextAlign.right,
      ),
    );
    notifyListeners();
  }

  void sendMessage(String message) {
    channel.sink.add(jsonEncode({"message": message}));
    addMessage('$message', false);
  }
}

// ChatScreen widget to display UI
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.71.128:7000/ws/chat/ROOMID'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(channel),
      child: Scaffold(
        appBar: AppBar(title: Text("Chat Room")),
        body: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) => Column(
            children: [
              // Display messages
              Expanded(
                child: ListView.builder(
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    // return Text("data");
                    return chatProvider.messages[index];
                  },
                ),
              ),
              // Text input and send button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        chatProvider.sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: Icon(Icons.send),
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

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
