import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';

class Smallcontainer extends StatelessWidget {
  const Smallcontainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kMainTeal2,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, 
              blurRadius: 10, 
              spreadRadius: 3, 
              offset: Offset(0, 4), 
            ),
          ],
        ),
      ),
    );
  }
}
