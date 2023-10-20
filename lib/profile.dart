import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdp_project/petList.dart';
import 'package:sdp_project/registerPet.dart';
import '/database/mongodb_service.dart';
import 'Session.dart';
import 'login.dart';

class Profile extends StatefulWidget {


  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final MongoDBService _mongoDBService = MongoDBService();
  // late Future<Map<String, dynamic>?> pet;

  dynamic id ="";
  late Future<Map<String, dynamic>?> user ;

  void getUser() async {

    try{

      id = await SessionManager.getUserId() as String;

      print(id);
    }catch(e){
      print(e);
    }

    final userResult = await _mongoDBService.findUserById(id);
    if (userResult != null) {
      setState(() {
        user = Future.value(userResult);

      });
    } else {
      print("Problem getting pet data.");
    }

    print("hlda");
    print(user);
    // email , namae ,mobile , address
  }

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Add your navigation logic here for each item in the bottom navigation bar.
      switch (index) {
        case 0:
        // Navigate to Home
          break;
        case 1:
        // Navigate to Add Pet
          break;
        case 2:
        // Navigate to Profile
          break;
        case 3:
        // Navigate to Logout
          break;
      }
    });
  }

  @override
  void initState()  {
    super.initState();
    _mongoDBService.connect();
    // Connect to MongoDB when the widget initializes
    getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue, // Set the background color to blue.

      child: Scaffold(
        backgroundColor: Colors.transparent, // Make the scaffold background transparent.

        appBar: AppBar(
          backgroundColor: Colors.transparent, // Make the app bar background transparent.
          elevation: 0,
          title: Text(
            'User Profile',
            style: TextStyle(
              color: Colors.white, // Set app bar text color to white.
            ),
          ),
        ),

        body: FutureBuilder<Map<String, dynamic>?>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white), // Set loading spinner color to white.
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(
                    color: Colors.red, // Set error text color to red.
                  ),
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'No user data available',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white.
                  ),
                ),
              );
            } else {
              final userData = snapshot.data!;

              // Access user fields
              final email = userData['email'];
              final name = userData['name'];
              final mobile = userData['mobile'];
              final address = userData['address'];

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white, // Set icon color to white.
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Name: $name',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white, // Set text color to white.
                      ),
                    ),
                    Text(
                      'Email: $email',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white, // Set text color to white.
                      ),
                    ),
                    Text(
                      'Mobile: $mobile',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white, // Set text color to white.
                      ),
                    ),
                    Text(
                      'Address: $address',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white, // Set text color to white.
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Pet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              label: 'Logout',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
              switch (index) {
                case 0:
                // Navigate to the Home page
                // Replace 'YourHomePage()' with the actual widget for the Home page
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PetList(),
                  ));
                  break;
                case 1:
                // Navigate to the Add Pet page
                // Replace 'YourAddPetPage()' with the actual widget for the Add Pet page
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MyRegisterPet(),
                  ));
                  break;
                case 2:
                // Navigate to the Profile page
                // Replace 'YourProfilePage()' with the actual widget for the Profile page
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Profile(),
                  ));
                  break;
                case 3:
                // Close the MongoDB connection (if needed)
                  _mongoDBService.close();

                  // Navigate to the login page and remove all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MyLogin(), // Replace MyLogin with your login screen
                    ),
                        (route) => false, // Remove all previous routes
                  );
                  break;
              }
            });
          },
        ),
      ),
    );
  }


}
