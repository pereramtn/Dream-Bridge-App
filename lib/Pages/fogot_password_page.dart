import 'package:dream_bridge_app/Pages/signin_page.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:dream_bridge_app/services/auth_services.dart';

class FogotPasswordPage extends StatefulWidget {
  const FogotPasswordPage({super.key});

  @override
  State<FogotPasswordPage> createState() => _FogotPasswordPageState();
}

class _FogotPasswordPageState extends State<FogotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      await AuthServices().sendPasswordResetEmail(email: email);

      // Show success message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Check Your Email'),
          content: const Text(
            'A password reset link has been sent to your email address.',
          ),
          actions: [
            TextButton(
             onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SigninPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "Forgot Password"),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kdefaultPadding),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                width: double.infinity,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kletGray.withOpacity(0.3),
                ),

                child: Column(
                  children: [
                    Image.asset("assets/Images/resetpassword.jpg", height: 150),
                    Text(
                      "Enter Email to Reset Password",
                      style: TextStyle(
                        fontSize: 25,
                        color: kMainTeal2,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Create a new secure password for\n your account",
                      style: TextStyle(
                        fontSize: 18,
                        color: kletdarkgray,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Form
                    Padding(
                      padding: const EdgeInsets.all(kdefaultPadding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // New Password
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Enter Email",
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: kMainGTeal1,
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 25),

                            // send reset link Button
                            _isLoading
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: _sendPasswordResetEmail,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kMainDarkBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                      child: const Text(
                                        "Send Reset Link",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Security Tips Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kMainDarkBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: kMainDarkBlue.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Security Tips",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kMainGTeal1,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Use at least 6 characters."),
                    Text("Include uppercase, lowercase, and numbers."),
                    Text("Avoid using easily guessable passwords."),
                    Text("Do not reuse old passwords."),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
