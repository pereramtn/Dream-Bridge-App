
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';

class SharedOnboard extends StatelessWidget {
  final String title;
  final String imagepath;
  final String description;

  const SharedOnboard({
    super.key,
    required this.title,
    required this.imagepath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
           const SizedBox(height: 20,),
           
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(30),
            child: Image.asset(imagepath, 
            fit: BoxFit.cover,),
          ),
      
          const SizedBox(height: 20,),
      
          Text(title, style: TextStyle(
            color: kMainGTeal1,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,),
      
          const SizedBox(height: 20,),
      
          Text(description, style: TextStyle(
            fontSize: 15,
            color: kletdarkgray,
            fontWeight: FontWeight.w500,
          ),
          ),
        ],
      ),
    );
  }
}
