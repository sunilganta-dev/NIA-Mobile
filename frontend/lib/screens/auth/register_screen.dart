import 'package:flutter/material.dart';
import 'package:nia_mobile/services/auth_service.dart';
import '../auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final username = TextEditingController();
  final firstName = TextEditingController();
  final middleName = TextEditingController(); // OPTIONAL
  final lastName = TextEditingController();
  final dob = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "CREATE ACCOUNT",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _field("Username *", username),
                  _field("First Name *", firstName),
                  _field("Middle Name (Optional)", middleName),
                  _field("Last Name *", lastName),
                  _field("Date of Birth (DD/MM/YYYY) *", dob),
                  _field("Email *", email),
                  _field("Password *", password, isPassword: true),

                  const SizedBox(height: 20),

                  if (error.isNotEmpty)
                    Text(error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14)),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: loading ? null : _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "REGISTER",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    setState(() {
      loading = true;
      error = "";
    });

    if (username.text.isEmpty ||
        firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        dob.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty) {
      setState(() {
        loading = false;
        error = "Please fill all required * fields.";
      });
      return;
    }

    final user =
        await AuthService.register(email.text.trim(), password.text.trim());

    if (user == null) {
      setState(() {
        loading = false;
        error = "Registration failed. Email may already exist.";
      });
      return;
    }

    // Email verification sent automatically by AuthService

    setState(() {
      loading = false;
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Verify Email"),
        content: const Text(
            "A verification link has been sent to your email. Please verify before logging in."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
