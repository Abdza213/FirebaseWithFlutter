import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sampleproject/users.dart';

class floatingButton extends StatefulWidget {
  @override
  State<floatingButton> createState() => _floatingButtonState();
}

class _floatingButtonState extends State<floatingButton> {
  String fullName = '';
  String password = '';
  apiUser s1 = new apiUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Container(
                width: double.infinity,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Full Name',
                    prefixIcon: Icon(FontAwesomeIcons.user),
                  ),
                  onChanged: (value) {
                    setState(() {
                      fullName = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 4,
              child: Container(
                width: double.infinity,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'password',
                    hintText: 'Password',
                    prefixIcon: Icon(FontAwesomeIcons.key),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                s1.addItem(
                  id: DateTime.now().toString(),
                  fullName: fullName,
                  password: password,
                );
                Navigator.pop(context);
              },
              child: Card(
                elevation: 10,
                child: Container(
                  width: 220,
                  height: 40,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
