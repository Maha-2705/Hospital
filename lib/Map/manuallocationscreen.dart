import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wellmed/Screens/showprofile.dart';

class ManualLocationScreen extends StatefulWidget {
  @override
  _ManualLocationScreenState createState() => _ManualLocationScreenState();
}

class _ManualLocationScreenState extends State<ManualLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doorController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();

  void _saveLocation() async {
    if (_formKey.currentState?.validate() ?? false) {
      final User? user = _auth.currentUser;
      if (user != null) {
        final userId = user.uid;

        await _databaseRef.child('Manual Location').child(userId).set({
          'name': _nameController.text,
          'door_no_flat_no': _doorController.text,
          'address': _addressController.text,
          'city': _cityController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location saved successfully')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompleteProfileScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter location Manually',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Wrapping the content in SingleChildScrollView
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              _buildLabel('Name'),
              _buildTextField(_nameController, 'Enter your Name'),
              SizedBox(height: 20),
              _buildLabel('Door number / Flat no'),
              _buildTextField(_doorController, 'Enter your door No'),
              SizedBox(height: 20),
              _buildLabel('Address'),
              _buildTextField(_addressController, 'Enter your Address'),
              SizedBox(height: 20),
              _buildLabel('City'),
              _buildTextField(_cityController, 'Enter your City'),
              SizedBox(height: 80),
              Center(
                child: ElevatedButton(
                  onPressed: _saveLocation,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF0000FF), // White text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    minimumSize:
                        Size(double.infinity, 40), // Button width and height
                  ),
                  child: Text('Save Location', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doorController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
