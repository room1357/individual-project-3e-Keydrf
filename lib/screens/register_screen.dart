import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.person_add, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 32),

              // Card Form
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Full Name
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Username
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Choose a username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.account_circle),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
