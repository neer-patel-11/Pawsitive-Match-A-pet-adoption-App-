  import 'package:flutter/material.dart';
  import '/database/mongodb_service.dart';
  import '/login.dart'; // Import your login screen file

  class HomeScreen extends StatefulWidget {
    final String username;

    HomeScreen({required this.username});

    @override
    _HomeScreenState createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
    final MongoDBService _mongoDBService = MongoDBService();

    // get username => username;
    //


    // Function to handle logout
    void _logout() {
      // Close the MongoDB connection (if needed)
      _mongoDBService.close();

      // Navigate to the login page and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MyLogin(), // Replace MyLogin with your login screen
        ),
            (route) => false, // Remove all previous routes
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Welcome, ${widget.username}'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'), // Path to your image
              fit: BoxFit.cover, // You can adjust the fit as needed
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: 20), // Add spacing

              ],
            ),
          ),
        ),
      );
    }
  }