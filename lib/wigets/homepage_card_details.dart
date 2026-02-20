import 'package:dream_bridge_app/Pages/signin_page.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:flutter/material.dart';

class HomepageCardDetails extends StatelessWidget {

  final String title1;
  final String description1;
  final IconData icon;
  final String title2;
  final String description2;
  final String title3;
  final String description3;
  

  const HomepageCardDetails({
    super.key,
    required this.title1,
    required this.description1,
    required this.icon,
    required this.title2,
    required this.description2,
    required this.title3,
    required this.description3,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kletGray,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 35),
          child: Column(
            children: [
              Text(title1, 
              style: TextStyle(
                fontSize: 25, 
                fontWeight: FontWeight.w700 ,
                color: kMainGTeal1),
              ),
              const SizedBox(height: 20),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: kMainTeal2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon( icon, size: 50, color: kMainTeal2)),
              const SizedBox(height: 20), 

        
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title2, 
                  style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),

                  Text(description2, 
              style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),
              Text(title3, 
              style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              Text(description3, 
              style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 40),
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon( Icons.lock_open, color: Colors.orangeAccent,),
                    SizedBox(width: 10),
                    Text(description1, 
                    style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SigninPage()));
                },
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                    color: kMainTeal2,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text("SIGN IN HERE TO UNLOCK", 
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.bold,
                      color: kMainWhite)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}