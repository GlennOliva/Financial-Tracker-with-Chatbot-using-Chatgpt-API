import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/client/api/consts.dart';

class ChatSupport extends StatefulWidget {
  const ChatSupport({super.key});

  @override
  State<ChatSupport> createState() => _ChatSupportState();
}

class _ChatSupportState extends State<ChatSupport> {

  final openAI = OpenAI.instance.build(token: OPENAI_API_KEY,
  baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5,
  ),
  ),
  enableLog: true,
  );

  final ChatUser  currentUser = ChatUser(id: '1', firstName: 'Aj' , lastName: 'Oliva');

  final ChatUser  gptChatUser = ChatUser(id: '2', firstName: 'GAMCO' , lastName: 'BOT' );

List<ChatMessage> messages = <ChatMessage>[];
List<ChatUser> typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PERSONAL GAMCO BOT'
        ),
      ),
      body: DashChat(
        currentUser: currentUser,
        typingUsers: typingUsers,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.cyan,
          containerColor: Colors.black,
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: messages,
        ),
    );
  }

 Future<void> getChatResponse(ChatMessage m) async {
  setState(() {
    messages.insert(0, m);
    typingUsers.add(gptChatUser);
  });

  // Extract user's input text
  String userText = m.text.toLowerCase();

  // Check if the user's input contains finance-related keywords
  if (containsFinanceKeywords(userText)) {
    // Convert ChatMessage to Messages
    List<Messages> messagesHistory = messages.reversed.map((m) {
      if (m.user == currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();

  final request = ChatCompleteText(
    model: GptTurbo0301ChatModel(),
    messages: messagesHistory,
    maxToken: 100, 
    
    );

    final response = await openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          messages.insert(0, ChatMessage(
            user: gptChatUser,
            createdAt: DateTime.now(),
            text: element.message!.content,
          ));
        });
      }
    }
  } else {
    // User's input does not contain finance-related keywords
    setState(() {
      messages.insert(0, ChatMessage(
        user: gptChatUser,
        createdAt: DateTime.now(),
        text: "Sorry, GAMCO Bot can only respond to finance-related queries.",
      ));
    });
  }

  setState(() {
    typingUsers.remove(gptChatUser);
  });
}

bool containsFinanceKeywords(String text) {
  List<String> financeKeywords = ["finance", "expense", "investment", "savings", "budget"];

  // Check if any of the finance keywords are present in the user's input
  return financeKeywords.any((keyword) => text.contains(keyword));
}

  // Rest of your code...
}

