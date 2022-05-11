import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sampleproject/Auth.dart';
import 'package:sampleproject/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class textFormFail extends StatefulWidget {
  @override
  State<textFormFail> createState() => _textFormFailState();
}

enum AuthMode { SignUp, Login }

class _textFormFailState extends State<textFormFail> {
  ////
  ////
  ////
  final ImagePicker _picker = ImagePicker();
  File? pickedImage;
  fetchImage() async {
    final image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    if (image == null) {
      return;
    }

    setState(() {
      pickedImage = File(image.path);
    });
  }

  ///
  ////
  ////
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController Firstpass = new TextEditingController();
  TextEditingController userName = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'userName': '',
  };
  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
        Firstpass.text = '';
        userName.text = '';
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        Firstpass.text = '';
        userName.text = '';
      });
    }
  }

////
  ///
  ///
  ///
  bool isLoading = true;
  showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              Navigator.pop(context);
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: _authMode == AuthMode.Login ? 370 : 570,
                width: double.infinity,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: _authMode == AuthMode.Login ? 50 : 10,
                      ),
                      if (_authMode == AuthMode.SignUp)
                        GestureDetector(
                          onTap: fetchImage,
                          child: pickedImage == null
                              ? CircleAvatar(
                                  radius: 90,
                                  backgroundColor: Colors.orange[200],
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        radius: 80,
                                        child: Icon(
                                          FontAwesomeIcons.user,
                                          size: 60,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(-10, 110),
                                        child: Icon(
                                          Icons.camera,
                                          size: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.orange[100],
                                  child: FutureBuilder(
                                    future:
                                        Future.delayed(Duration(seconds: 2)),
                                    builder: (context, snapshot) {
                                      return snapshot.connectionState !=
                                              ConnectionState.waiting
                                          ? ClipOval(
                                              child: Image.file(
                                                pickedImage!,
                                                fit: BoxFit.cover,
                                                width: 180,
                                                height: 180,
                                              ),
                                            )
                                          : CircularProgressIndicator();
                                    },
                                  ),
                                ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        constraints: BoxConstraints(
                          minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                          maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                        ),
                        child: _authMode == AuthMode.SignUp
                            ? TextFormField(
                                controller: userName,
                                enabled: _authMode == AuthMode.SignUp,
                                decoration: InputDecoration(
                                  hintText: 'User Name',
                                  prefixIcon: _authMode == AuthMode.SignUp
                                      ? Icon(FontAwesomeIcons.user)
                                      : null,
                                  label: Text('User Name'),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(15),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Invalid user name !';
                                  }
                                },
                                onSaved: (val) {
                                  _authData['userName'] = val.toString();
                                },
                              )
                            : null,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          prefixIcon: Icon(Icons.email),
                          label: Text('E-mail'),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(15),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val!.isEmpty || !val.contains('@')) {
                            return 'Invalid email !';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _authData['email'] = val.toString();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: Firstpass,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.key),
                          label: Text('Password'),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(15),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val!.isEmpty || val.contains(' ')) {
                            return 'Invalid password!';
                          } else if (val.length < 5) {
                            return 'short password';
                          }
                        },
                        onSaved: (val) {
                          _authData['password'] = val.toString();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: _submit,
                        child: isLoading
                            ? Text(_authMode == AuthMode.Login
                                ? 'LOGIN'
                                : 'SING UP')
                            : Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      TextButton(
                        onPressed: _switchAuthMode,
                        child: isLoading
                            ? Text(_authMode == AuthMode.Login
                                ? 'SING UP'
                                : 'LOGIN')
                            : Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      return;
    } else {
      FocusScope.of(context).unfocus();

      _formKey.currentState!.save();
    }
    ////
    ////

    setState(() {
      isLoading = false;
    });
    SharedPreferences s1 = await SharedPreferences.getInstance();
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
        var x = await Provider.of<Auth>(context, listen: false).addIdUser;
        print('list userIdzzzzzzzzzzzzzzzzz ==== ' + '${x[0].id}');
        s1.setString('key', '${x[0].id}');
        s1.setBool('fetch', true);

        ///
        ///

        ///
        ////
        ////
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: ((context) => homePage(
                      keyItem: s1.getString('key') as String,
                    ))));
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email']!,
          _authData['password']!,
        );
        var x = await Provider.of<Auth>(context, listen: false).addIdUser;
        print('list userIdzzzzzzzzzzzzzzzzz ==== ' + '${x[0].id}');
        ////
        ///
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(x[0].id + '.jpg');
        var urlImage;
        if (pickedImage != null) {
          await ref.putFile(pickedImage!);
          urlImage = await ref.getDownloadURL();
          await ref.putFile(pickedImage!);
        } else {
          urlImage =
              'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png';
        }

        print('urlImage ======================= ${urlImage}');
        ////
        ///
        s1.setString('key', '${x[0].id}');
        s1.setBool('fetch', true);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: ((context) => homePage(
                      keyItem: s1.getString('key') as String,
                    ))));
        ////
        ///
        await FirebaseFirestore.instance
            .collection('newAccount/${x[0].id}/message')
            .add({
          'userName': _authData['userName'],
          'email': _authData['email']!,
          'password': _authData['password']!,
          'image_url': urlImage,
        });
      }
    } catch (error) {
      setState(() {
        isLoading = true;
      });
      var errorMessage = 'Authenticatio Faild';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      showErrorDialog(errorMessage);
    }
  }
}
