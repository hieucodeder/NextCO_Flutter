import 'package:flutter/material.dart';

class ImageViewerScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  const ImageViewerScreen({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  _ImageViewerScreenState createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return Center(
            child: Hero(
              tag: widget.imageUrls[index],
              child: InteractiveViewer(
                child: Image.network(
                  widget.imageUrls[index],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
