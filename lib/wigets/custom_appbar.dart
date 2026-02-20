import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  final String appbar_title;
  
  const CustomAppbar({
    super.key, 
    required this.appbar_title});
   
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kMainGTeal1,
      shadowColor: Colors.black26,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),

      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: kMainWhite),
        onPressed: () => Navigator.pop(context),
      ),

      title: Text(
        appbar_title,
        style: TextStyle(
          color: kMainWhite,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    
  }
    @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
