import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomAppbarNoBack extends StatelessWidget
    implements PreferredSizeWidget {
      
  final String appbarTitle;

  const CustomAppbarNoBack({
    super.key,
    required this.appbarTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kMainGTeal1,
      shadowColor: Colors.black26,

      // Removes automatic back button
      automaticallyImplyLeading: false,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),

      title: Text(
        appbarTitle,
        style: const TextStyle(
          color: kMainWhite,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),

      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}