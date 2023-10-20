import 'package:flutter/material.dart';
import '/database/mongodb_service.dart';

class MyRegister extends StatefulWidget {
  MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final MongoDBService _mongoDBService = MongoDBService();

  @override
  void initState() {
    super.initState();
    _mongoDBService.connect(); // Connect to MongoDB when the widget initializes
  }

  @override
  void dispose() {
    _mongoDBService.close(); // Close the MongoDB connection when the widget is disposed
    super.dispose();
  }

  void _registerUser() async {
    // Ensure email and password are not empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in both email and password.'),
        ),
      );
      return;
    }

    // Create a user map with the necessary fields
    Map<String, dynamic> user = {
      'email': _emailController.text,
      'password': _passwordController.text,
      'name': _nameController.text,
      'mobile': _mobileController.text,
      'address': _addressController.text,
      // ... other fields ...
    };

    try {
      // Check if the user already exists with the provided email
      final existingUser = await _mongoDBService.findUserByEmail(_emailController.text);
      if (existingUser != null) {
        // User with the same email already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User already exists.'),
          ),
        );
        return;
      }

      // If the user doesn't exist, proceed with registration
      await _mongoDBService.registerUser(user);

      // Registration successful, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User registered successfully.'),
        ),
      );

      // Clear the text fields after successful registration
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      _mobileController.clear();
      _addressController.clear();
    } catch (e) {
      // Handle any errors that occurred during registration
      print('Error during registration: $e');
      // You might want to show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Customize background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: TextStyle(color: Colors.white, fontSize: 33, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: _nameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: _mobileController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Mobile",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: _addressController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: _emailController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue, // Button background color
                    child: IconButton(
                      color: Colors.white,
                      onPressed: _registerUser,
                      icon: Icon(
                        Icons.arrow_forward,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
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
