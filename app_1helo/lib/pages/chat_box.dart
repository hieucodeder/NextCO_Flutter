import 'package:app_1helo/model/body_chatbot_answer.dart';
import 'package:app_1helo/model/chatbot_answer_model.dart';
import 'package:app_1helo/provider/provider_color.dart';
import 'package:app_1helo/service/chatbot_answer_service.dart';
import 'package:app_1helo/service/chatbot_getcode_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  String? _initialMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialMessage();
  }

  Future<void> _loadInitialMessage() async {
    final chatbotData = await fetchChatbotGetcode();
    if (chatbotData != null) {
      setState(() {
        _initialMessage = chatbotData.initialMessages;
      });
      _messages.add({
        'type': 'bot',
        'text': _initialMessage ?? 'Lỗi',
        'image': ['resources/logo_chatbox.jpg'],
      });
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userQuery = _controller.text.trim();

    setState(() {
      _messages.add({'type': 'user', 'text': userQuery});
      _isLoading = true;
    });
    _controller.clear();
    BodyChatbotAnswer chatbotRequest = BodyChatbotAnswer(
      chatbotCode: "a4db1b36-8e24-4fee-bbef-70ca4413e988",
      chatbotName: "Chatbot 2024/12/05, 16:35:57",
      collectionName: "a4db1b36-8e24-4fee-bbef-70ca4413e988",
      customizePrompt: "",
      fallbackResponse:
          "Dạ, mình là AI Chabot. Mình chưa có thông tin chính xác cho vấn đề đó của bạn!",
      genModel: "gpt-4o-mini",
      history: [],
      intentQueue: [],
      language: "Vietnamese",
      platform: "website",
      query: userQuery,
      rerankModel: "gpt-4o-mini",
      rewriteModel: "gpt-4o-mini",
      slots: [],
      slotsConfig: [],
      systemPrompt:
          "Bạn là một trợ lý ảo thông minh có kiến thức cao với chuyên môn trong việc cung cấp các câu trả lời chi tiết và sâu sắc cho câu hỏi của người dùng dưới nhiều lĩnh vực. Vai trò của bạn là tương tác với người dùng một cách thân thiện, đảm bảo rằng bạn hiểu câu hỏi của họ và cung cấp cho họ thông tin phù hợp nhất.",
      temperature: 0,
      threadHold: 0.1,
      topCount: 4,
      type: "normal",
      userId: "bb9fc044-bb8f-4d23-9732-ed722bfa7618",
      userIndustry: "Social",
    );

    print("Sending request to API...");

    ChatbotAnswerModel? response = await fetchApiResponse(chatbotRequest);

    setState(() {
      _isLoading = false;
    });
    if (response != null) {
      print("API response: ${response.message}");

      setState(() {
        _isLoading = false;
        List<String> images = response.data.images.isNotEmpty
            ? response.data.images
            : ['resources/logo_chatbox.jpg'];
        _messages.add({
          'type': 'bot',
          'text': response.data.message,
          'image': images,
        });
      });
    } else {
      print("API response is null, using default response.");

      setState(() {
        _messages.add({
          'type': 'bot',
          'text': 'Bot không thể trả lời, vui lòng thử lại.',
          'image': 'resources/logo_chatbox.jpg',
        });
      });
    }

    _controller.clear();
    print("Input field cleared");
  }

  @override
  Widget build(BuildContext context) {
    final selectColors = Provider.of<Providercolor>(context).selectedColor;
    final textChatBot =
        GoogleFonts.robotoCondensed(fontSize: 15, color: Colors.black);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: selectColors,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
            icon: const Icon(Icons.arrow_back)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('resources/logo_chatbox.jpg'),
              radius: 16,
            ),
            const SizedBox(width: 10),
            Text(
              'TRỢ LÝ AI NEXTCO',
              style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];

                // Tùy chỉnh căn chỉnh tin nhắn
                final isUser = message['type'] == 'user';
                return Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isUser &&
                        message.containsKey('image') &&
                        message['image'] is List<String>) ...[
                      // Loop through the images in the list
                      for (var imageUrl in message['image'])
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            backgroundImage: imageUrl.startsWith('http')
                                ? NetworkImage(imageUrl)
                                : AssetImage(imageUrl) as ImageProvider,
                            radius: 20,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                    ],
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser ? selectColors : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['text']!,
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 14,
                              color: isUser ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          if (_isLoading) ...[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: const AlwaysStoppedAnimation(45 / 360),
                    child: Icon(
                      FontAwesomeIcons.circleNotch,
                      color: selectColors,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bot đang trả lời...',
                    style: textChatBot,
                  ),
                ],
              ),
            ),
          ],
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      hintStyle: textChatBot,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                      _isLoading ? Icons.hourglass_empty : Icons.send_rounded,
                      color: selectColors),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Được hỗ trợ bởi',
                  style: textChatBot,
                ),
                Text(
                  ' SmartChat |',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ' AI Academy',
                  style: textChatBot,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
