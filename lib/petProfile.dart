import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdp_project/petList.dart';
import 'package:sdp_project/profile.dart';
import 'package:sdp_project/registerPet.dart';
import '/database/mongodb_service.dart';
import 'Session.dart';
import 'login.dart';

class PetProfile extends StatefulWidget {
  final id;

  PetProfile(this.id, {Key? key}) : super(key: key);

  @override
  _PetProfileState createState() => _PetProfileState(id);
}

class _PetProfileState extends State<PetProfile> {
  final MongoDBService _mongoDBService = MongoDBService();
  late Future<Map<String, dynamic>?> pet = Future.value(null);
  final id;

  late dynamic user = Future.value(null);

  _PetProfileState(this.id);

  late dynamic userId;
  late dynamic petData;
  late dynamic userData;

  int _selectedIndex = 0;
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

  // Use an async method to get the pet data and user data
  Future<void> getData() async {
    final petResult = await _mongoDBService.getPet(id);
    if (petResult != null) {
      setState(() {
        petData = petResult;
        userId = petResult["userKey"];
        getUser();
      });
    } else {
      print("Problem getting pet data.");
    }
  }

  void getUser() async {
    final userResult = await _mongoDBService.findUserById(userId.toString());
    if (userResult != null) {
      setState(() {
        userData = userResult;
      });
    } else {
      print("Problem getting user data.");
    }
  }

  @override
  void initState() {
    super.initState();
    _mongoDBService.connect(); // Connect to MongoDB when the widget initializes
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (petData != null)
              Column(
                children: <Widget>[
                  Text(
                    petData['name'],
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.memory(
                      base64Decode(petData['image']),
                      fit: BoxFit.cover,
                      width: 250,
                      height: 250,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Age: ${petData['age']}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Type: ${petData['type']}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Subtype: ${petData['subtype']}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Gender: ${petData['gender'] ? 'Male' : 'Female'}',
                    style: TextStyle(
                      fontSize: 20,
                      color: petData['gender'] ? Colors.lightBlueAccent : Colors.pinkAccent,
                    ),
                  ),
                ],
              ),
            if (userData != null)
              Column(
                children: <Widget>[
                  Text(
                    'Owner Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: ${userData['email']}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Name: ${userData['name']}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Mobile: ${userData['mobile']}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'Address: ${userData['address']}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.blue),
            label: 'Add Pet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.blue),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app, color: Colors.blue),
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => PetList(),
                ));
                break;
              case 1:
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MyRegisterPet(),
                ));
                break;
              case 2:
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Profile(),
                ));
                break;
              case 3:
                _mongoDBService.close();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MyLogin(),
                  ),
                      (route) => false,
                );
                break;
            }
          });
        },
      ),
    );
  }

}
