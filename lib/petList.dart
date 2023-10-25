import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdp_project/Homescreen.dart';
import 'package:sdp_project/petProfile.dart';
import 'package:sdp_project/profile.dart';
import 'package:sdp_project/registerPet.dart';
import '/database/mongodb_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'login.dart';


class PetList extends StatefulWidget {
  PetList({Key? key}) : super(key: key);

  @override
  _PetState createState() => _PetState();
}

class _PetState extends State<PetList> {
  final MongoDBService _mongoDBService = MongoDBService();
  late Future<List<Map<String, dynamic>>> pets;

  void getList() async {
    pets = _mongoDBService.findPets();
  }

  @override
  void initState() {
    super.initState();
    _mongoDBService.connect();
    getList();
  }

  @override
  void dispose() {
    _mongoDBService.close();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          'Pawsitive Match',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: pets,
          builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Map<String, dynamic>>? data = snapshot.data;

              return ListView.builder(
                itemCount: data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PetProfile(data![index]['_id']),
                      ));
                    },
                    child: Center(
                      child: Card(
                        elevation: 10,
                        margin: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: Colors.blueGrey,
                        child: Container(
                          width: 300,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.indigo],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data?[index]['name'],
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
                                  base64Decode(data?[index]['image']),
                                  fit: BoxFit.cover,
                                  width: 250,
                                  height: 250,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Gender: ${data?[index]['gender'] ? 'Male' : 'Female'}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: data?[index]['gender'] ? Colors.lightBlueAccent : Colors.pinkAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
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

    );
  }
}
