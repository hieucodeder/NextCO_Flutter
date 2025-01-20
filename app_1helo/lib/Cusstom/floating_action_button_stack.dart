import 'package:app_1helo/pages/chat_box.dart';
import 'package:app_1helo/pages/facebookPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FloatingActionButtonStack extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Visibility(
          visible: isExpanded,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 150.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: FloatingActionButton(
                heroTag: 'uniqueTagForButton3',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FacebookPage()),
                  );
                },
                tooltip: 'Button 3',
                backgroundColor: selectedColor,
                child: const Icon(
                  FontAwesomeIcons.facebookF,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: isExpanded,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: FloatingActionButton(
                heroTag: 'uniqueTagForButton2',
                onPressed: () {},
                backgroundColor: selectedColor,
                tooltip: 'Button 2',
                child: const Icon(
                  FontAwesomeIcons.phone,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: isExpanded,
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
                backgroundColor: selectedColor,
                tooltip: 'Button 1',
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
            onPressed: _toggleButtons,
            tooltip: 'Toggle',
            backgroundColor: selectedColor,
            child: Icon(
              isExpanded ? Icons.close : Icons.support_agent_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
