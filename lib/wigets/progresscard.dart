import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatefulWidget {
  final double progressValue;
  final int total;
  const ProgressCard({
    super.key,
    required this.progressValue,
    required this.total,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  @override
  Widget build(BuildContext context) {
    int done = (widget.progressValue * widget.total).toInt(); //0.3*100 =30
    int percentage = (widget.progressValue * 100).toInt();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: AlignmentGeometry.bottomRight,
          colors: [kMainTeal3, kbtnBlue],
        ),
        boxShadow: [
        BoxShadow(
          color: Colors.black,
          offset: Offset(0,2),
          blurRadius: 2,
        )
      ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Profile Completion",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: kMainWhite,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Please complete your profile to unlock more accurate and personalized results!",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: kbtngray,
              ),
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: widget.progressValue,
              backgroundColor: kletdarkgray,
              valueColor: AlwaysStoppedAnimation(kMainWhite),
              minHeight: 10,
              borderRadius: BorderRadius.circular(100),
            ),

            const SizedBox(height: 3),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buidTag("Done", done.toString()),
                _buidTag("Total", widget.total.toString()),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buidTag(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kletGray,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: kletGray,
          ),
        ),
      ],
    );
  }
}
