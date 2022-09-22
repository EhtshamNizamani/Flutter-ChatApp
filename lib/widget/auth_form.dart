// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:io';

import 'package:chat_app/widget/image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm({Key? key, required this.submit, required this.isLoading})
      : super(key: key);
  bool? isLoading;
  final void Function(String? userName, String? userEmail, String? pssword,
      bool isLogin, BuildContext context, File? userImage) submit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userName;
  var _userEmail;
  var _userPassword;
  File? _userImage;
  void _pickedImage(File? image) {
    print('in picked images');
    _userImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    if (!_isLogin) {
      if (_userImage == null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Image is not Choosen',
            style: TextStyle(color: Theme.of(context).errorColor),
          )),
        );
        return;
      }
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submit(
          _userName, _userEmail, _userPassword, _isLogin, context, _userImage);
      print('object');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) Photos(_pickedImage),
                    TextFormField(
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: 'Email Adress'),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        validator: (value) {
                          if (value!.length < 4) {
                            return 'Please enter atleast 4 charecter name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(labelText: 'User Name'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value!.length < 7) {
                          return 'Password should be more than 6 letters';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.isLoading!) const CircularProgressIndicator(),
                    if (!widget.isLoading!)
                      RaisedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                      ),
                    if (!widget.isLoading!)
                      FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin
                                ? 'Create New Account '
                                : 'I have already an account',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
