import 'package:flutter/material.dart';

class CustmButton extends StatelessWidget {
  final String btnname;
  final Color btncolour;
  final IconData? icon;

  const CustmButton({
    super.key,
    required this.btnname,
    required this.btncolour,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: btncolour,
      ),

      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Text(
              btnname,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
