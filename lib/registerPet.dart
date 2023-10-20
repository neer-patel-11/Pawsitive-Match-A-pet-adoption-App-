import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdp_project/Session.dart';
import 'package:sdp_project/petList.dart';
import '/database/mongodb_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'login.dart';

class MyRegisterPet extends StatefulWidget {
  MyRegisterPet({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegisterPet> {
  final MongoDBService _mongoDBService = MongoDBService();

  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petTypeController = TextEditingController();
  final TextEditingController _subTypeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  File? image;

  String? imageSelectionMessage = "Select an Image"; // Message to inform user about image selection.

  void _registerPet() async {
    dynamic id = "";
    try {
      id = await SessionManager.getUserId() as String;
    } catch (e) {
      print(e);
    }

    if (image == null) {
      setState(() {
        imageSelectionMessage = "Please pick an image from the gallery.";
      });
      return;
    }

    if (_petNameController.text.isEmpty ||
        _petTypeController.text.isEmpty ||
        _subTypeController.text.isEmpty ||
        _ageController.text.isEmpty) {
      setState(() {
        imageSelectionMessage = "All fields are required.";
      });
      return;
    }

    Map<String, dynamic> pet = {
      "name": _petNameController.text,
      "type": _petTypeController.text,
      "subtype": _subTypeController.text,
      "age": _ageController.text,
      "userKey": id,
      "gender": genderController,
      "image": base64Encode(image!.readAsBytesSync()),
    };

    await _mongoDBService.registerPet(pet);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => PetList(),
    ));


  }

  @override
  void initState() {
    super.initState();
    _mongoDBService.connect();
  }

  Future pickImage() async {
    try {
      final selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (selectedImage == null) {
        setState(() {
          imageSelectionMessage = "No image selected.";
        });
        return;
      }
      final imageTemp = File(selectedImage.path);
      setState(() {
        image = imageTemp;
        imageSelectionMessage = null; // Clear the message.
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  bool genderController = true;

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
        // Navigate to Home
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => PetList(),
          ));
          break;
        case 1:
        // Navigate to Add Pet
          break;
        case 2:
        // Navigate to Profile
          break;
        case 3:
          _mongoDBService.close();
          // Navigate to the login page and remove all previous routes
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MyLogin(),
            ),
                (route) => false,
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Register a Pet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MaterialButton(
                color: Colors.blue,
                child: Text(
                  "Pick Image from Gallery",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: pickImage,
              ),
              if (imageSelectionMessage != null)
                Text(
                  imageSelectionMessage!,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              SizedBox(height: 20),
              _buildTextField(
                _petNameController,
                "Pet Name",
              ),
              SizedBox(height: 20),
              _buildTextField(
                _petTypeController,
                "Pet Type",
              ),
              SizedBox(height: 20),
              _buildTextField(
                _subTypeController,
                "Sub Type",
              ),
              SizedBox(height: 20),
              _buildTextField(
                _ageController,
                "Age",
              ),
              SizedBox(height: 20),
              _buildGenderSelection(),
              SizedBox(height: 40),
              _buildRegisterButton(),
            ],
          ),
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
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      style: TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        Radio(
          value: true,
          groupValue: genderController,
          onChanged: (value) {
            setState(() {
              genderController = value!;
            });
          },
          activeColor: Colors.blue,
        ),
        Text(
          "Male",
          style: TextStyle(color: Colors.white),
        ),
        Radio(
          value: false,
          groupValue: genderController,
          onChanged: (value) {
            setState(() {
              genderController = value!;
            });
          },
          activeColor: Colors.pink,
        ),
        Text(
          "Female",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Center(
        child: MaterialButton(
        color: Colors.blue,
        child: Text(
        "Register Pet",
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
    ),
    ),
    onPressed: _registerPet,
    )
    );

  }
}

