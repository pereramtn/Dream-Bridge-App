import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String imageURL;
  final String title;
  final String description;
  final Color color;

  const CustomContainer({
    super.key, 
    required this.imageURL, 
    required this.title, 
    required this.description,
    required this.color,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child:Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imageURL,
                 height: 170,
                 width: double.infinity,
                 fit: BoxFit.cover,),
              Text(title, style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kMainDarkBlue
              ),),
              Text(description),
            ],
          ),
        ) ,
      ),
    );
  }
}