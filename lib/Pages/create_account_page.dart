import 'package:dream_bridge_app/Pages/onboard_screen.dart';
import 'package:dream_bridge_app/Pages/signin_page.dart';
import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/constants/responsive.dart';
import 'package:dream_bridge_app/services/auth_services.dart';
import 'package:dream_bridge_app/wigets/custm_button.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _agreeTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signInUser() async {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please agree to Terms & Conditions")),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Passwords do not match"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return;
      }
      await AuthServices().createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardScreen()),
        );
      }
    } catch (e) {
      
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error Registering user"),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  finally {
    setState(() {
      _isLoading = false;
    });
  }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "CREATE ACCOUNT"),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kdefaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "assets/Images/createaccount.jpg",
                        height: 180,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Enter Your Email & Password For Create New Account",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter Your E-mail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                    ),
                    keyboardType: TextInputType.emailAddress,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Your E-mail";
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Please Enter a valid E-mail";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Enter Your Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: "Confirm Your Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Checkbox(
                        value: _agreeTerms,
                        activeColor: kMainTeal2,
                        onChanged: (v) => setState(() => _agreeTerms = v!),
                      ),
                      const Expanded(
                        child: Text("I agree to the Terms & Conditions"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: _signInUser,
                            child: CustmButton(
                              btnname: "CREATE ACCOUNT",
                              btncolour: kMainTeal2,
                            ),
                          ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SigninPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "SignIn Here",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }
}
