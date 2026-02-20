import 'dart:async';
import 'package:flutter/material.dart';

class SlideShowImages extends StatefulWidget {
  const SlideShowImages({super.key});

  @override
  State<SlideShowImages> createState() => _SlideShowImagesState();
}

class _SlideShowImagesState extends State<SlideShowImages> {

  final PageController controller = PageController();
  int currentPage = 0;

  final List<String> images = [
    "assets/Images/home1.jpg",
    "assets/Images/home2.jpg",
    "assets/Images/home3.jpg",
  ];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentPage < images.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: controller,
        itemCount: images.length,
        onPageChanged: (index) {
          currentPage = index;
        },
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              images[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
