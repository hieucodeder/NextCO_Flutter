import 'package:app_1helo/pages/chat_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FloatingActionButtonStack extends StatefulWidget {
  final bool isExpanded;
  final Color selectedColor;
  final VoidCallback _toggleButtons;

  const FloatingActionButtonStack({
    super.key,
    required this.isExpanded,
    required this.selectedColor,
    required VoidCallback toggleButtons,
  }) : _toggleButtons = toggleButtons;

  @override
  State<FloatingActionButtonStack> createState() =>
      _FloatingActionButtonStackState();
}

class _FloatingActionButtonStackState extends State<FloatingActionButtonStack> {
  bool isLoading = false;

  Future<void> _launchFacebookProfile(BuildContext context) async {
    final Uri url = Uri.parse("https://www.facebook.com/phanmemnextco");

    setState(() {
      isLoading = true;
    });

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không thể mở URL.")),
        );
        debugPrint("Không thể mở URL: $url");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã xảy ra lỗi trong quá trình mở URL.")),
      );
      debugPrint("Lỗi mở URL: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Visibility(
          visible: widget.isExpanded,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 150.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : FloatingActionButton(
                        heroTag: 'uniqueTagForButton3',
                        onPressed: () {
                          _launchFacebookProfile(context);
                        },
                        tooltip: 'Facebook',
                        backgroundColor: widget.selectedColor,
                        child: const Icon(
                          FontAwesomeIcons.facebookF,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.isExpanded,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Tooltip(
                message: '08917213721', // Số điện thoại
                textStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  color: widget.selectedColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FloatingActionButton(
                  heroTag: '08917213721',
                  onPressed: () {
                    // Hành động khi nhấn nút
                  },
                  backgroundColor: widget.selectedColor,
                  tooltip: '08917213721',
                  child: const Icon(
                    FontAwesomeIcons.phone,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.isExpanded,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: FloatingActionButton(
                heroTag: 'uniqueTagForButton1',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatBox()),
                  );
                },
                backgroundColor: widget.selectedColor,
                tooltip: 'Chatbot',
                child: const Icon(
                  FontAwesomeIcons.commentDots,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            onPressed: widget._toggleButtons,
            tooltip: 'Toggle',
            backgroundColor: widget.selectedColor,
            child: Icon(
              widget.isExpanded ? Icons.close : Icons.support_agent_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
