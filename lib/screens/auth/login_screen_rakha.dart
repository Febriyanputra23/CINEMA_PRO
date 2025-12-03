import 'package:flutter/material.dart';
import '../../services/movie_service_febriyan.dart';
import '../home/home_screen_rakha.dart';
import 'register_screen_rakha.dart';

class LoginScreen_Rakha extends StatefulWidget {
  @override
  _LoginScreen_RakhaState createState() => _LoginScreen_RakhaState();
}

class _LoginScreen_RakhaState extends State<LoginScreen_Rakha> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  void _login_Rakha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    _errorMessage = '';

    try {
      final user = await FirebaseService_Febriyan().signInWithEmail_Febriyan(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen_Rakha()),
        );
      } else {
        setState(() => _errorMessage = 'Login failed');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateEmail_Rakha(String? email) {
    return email?.endsWith('@student.univ.ac.id') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 40),
                Icon(Icons.movie, size: 80, color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  'CineBooking',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(height: 8),
                Text(
                  'Login to book your movie tickets',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 40),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@student.univ.ac.id',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter email';
                    if (!_validateEmail_Rakha(value))
                      return 'Must be @student.univ.ac.id';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter password';
                    if (value!.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Error Message
                if (_errorMessage.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text(_errorMessage,
                                style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],

                // Login Button
                _isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _login_Rakha,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Login',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                SizedBox(height: 16),

                // Forgot Password
                Align(
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password?',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ),
                SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child:
                          Text('OR', style: TextStyle(color: Colors.grey[600])),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 20),

                // Register Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: TextStyle(color: Colors.grey[600])),
                    SizedBox(width: 4),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen_Rakha()),
                      ),
                      child: Text('Register',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
