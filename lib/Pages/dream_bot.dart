import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dream_bridge_app/constants/colors.dart';

class DreamBotPage extends StatefulWidget {
  const DreamBotPage({super.key});

  @override
  State<DreamBotPage> createState() => _DreamBotPageState();
}

class _DreamBotPageState extends State<DreamBotPage> {
  final TextEditingController _userMessage = TextEditingController();

  // Groq API Key
  static const String apiKey = ""; //  GROQ API KEY

  final List<Message> _messages = [];
  bool isLoading = false;

  Future<void> sendMessage() async {
    final message = _userMessage.text.trim();

    if (message.isEmpty) return;

    _userMessage.clear();

    setState(() {
      _messages.add(
        Message(isUser: true, message: message, date: DateTime.now()),
      );
      isLoading = true;
    });

    try {
      // Send message to Groq API
      final response = await http.post(
        Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },

        // Request body with system prompt and user message
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are DreamBot, a helpful and intelligent career guidance assistant."
                  "Your purpose is to assist users by answering career related questions clearly, briefly, and professionally.Your purpose is to assist users by answering career-related questions clearly, briefly, and professionally."
                  "Reply in a friendly, supportive, and user-friendly tone."
                  " Provide accurate career guidance, education advice, and job-related information.Keep answers concise, clear, and easy to understand."
                  "After the first message, do not repeat greetings unless the conversation restarts."
                  "Maintain a professional and encouraging tone.",
            },
            {"role": "user", "content": message},
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final botReply =
            data["choices"][0]["message"]["content"] ?? "No response";

        setState(() {
          _messages.add(
            Message(isUser: false, message: botReply, date: DateTime.now()),
          );
        });
      } else {
        setState(() {
          _messages.add(
            Message(
              isUser: false,
              message: "Error: ${response.statusCode}",
              date: DateTime.now(),
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
          Message(
            isUser: false,
            message: "Something went wrong: $e",
            date: DateTime.now(),
          ),
        );
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _userMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kMainTeal4, kMainTeal2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  "assets/Images/dreambot.jpg",
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Dream Bot",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return Messages(
                  isUser: message.isUser,
                  message: message.message,
                  date: DateFormat('HH:mm').format(message.date),
                );
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 25),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _userMessage,
                    decoration: InputDecoration(
                      hintText: "Ask Dream Bot...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [kMainTeal4, kMainTeal2]),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Message Bubble Widget

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: isUser ? 80 : 10,
        right: isUser ? 10 : 80,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: isUser
            ? const LinearGradient(
                colors: [kMainTeal4, kMainTeal2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  const Color.fromARGB(255, 162, 159, 159),
                  const Color.fromARGB(138, 209, 209, 209),
                ],
              ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              color: isUser ? Colors.black87 : Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: isUser ? Colors.black54 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// Message Model

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}
