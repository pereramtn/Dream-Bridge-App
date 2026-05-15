import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_bridge_app/Pages/Profile_completion_page.dart';
import 'package:dream_bridge_app/Pages/create_account_page.dart';
import 'package:dream_bridge_app/Pages/main_screen.dart';
import 'package:dream_bridge_app/Pages/fogot_password_page.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/models/user_models.dart';
import 'package:dream_bridge_app/providers/user_providers.dart';
import 'package:dream_bridge_app/services/auth_services.dart';
import 'package:dream_bridge_app/wigets/custm_button.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _signInUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final userCredential =
          await AuthServices().signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('Students') // same collection for profile & assessment
          .doc(uid)
          .get();

      if (doc.exists) {
        final userModel = StudentModel.fromFirestore(uid, doc.data()!);
        Provider.of<UserProvider>(context, listen: false).setUser(userModel);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => userModel.profileCompleted
                ? const MainScreen()
                : const ProfileCompletionPage(),
          ),
        );
      } else {
        // If no profile document exists yet
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await AuthServices().signInWithGoogle();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Error signing in with Google. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "SIGN IN"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kdefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset("assets/Images/signin.jpg", height: 180),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter Your Personal Details",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Please Enter a valid Email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Your E-mail",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter a valid Password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Your password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Text(
                            "Remember Me for the next time",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: kletGray),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              activeColor: kMainGTeal1,
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() => _rememberMe = value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : GestureDetector(
                              onTap: _signInUser,
                              child: CustmButton(
                                btnname: "SIGN IN",
                                btncolour: kMainTeal2,
                              ),
                            ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _signInWithGoogle,
                        child: CustmButton(
                          btnname: "SIGN IN WITH GOOGLE",
                          icon: FontAwesomeIcons.google,
                          btncolour: kbtngreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(kdefaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CreateAccountPage()),
                                );
                              },
                              child: const Text(
                                "Don't have an account ?",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const FogotPasswordPage()),
                                );
                              },
                              child: const Text(
                                "Forgot Password ?",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
