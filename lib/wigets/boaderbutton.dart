import 'package:flutter/material.dart';

class Boaderbutton extends StatelessWidget {
  final String btnname;
  final Color bodercolour;
  final Color txtcolour;

  const Boaderbutton({
    super.key,
    required this.btnname,
    required this.bodercolour,
    required this.txtcolour,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: bodercolour, width: 3),
      ),

      child: Center(
        child: Text(
          btnname,
          style: TextStyle(
            color: txtcolour,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
