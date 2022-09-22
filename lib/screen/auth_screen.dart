import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widget/auth_form.dart';
import '../format_error.dart/format_errors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const route = 'auth-screen';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  var isLoading = false;
  String downloadURL = '';
  void _submitingAuthForm(String? userName, String? userEmail, String? password,
      bool isLogin, BuildContext ctx, File? userImage) async {
    UserCredential userResult;
    print('submiting');
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        await auth.signInWithEmailAndPassword(
            email: userEmail!, password: password!);
        // print('login');
      } else {
        userResult = await auth.createUserWithEmailAndPassword(
            email: userEmail!, password: password!);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(userResult.user!.uid);
        await ref.putFile(userImage!).then((p0) => {ref.getDownloadURL()});
        downloadURL = await FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child(userResult.user!.uid)
            .getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userResult.user!.uid)
            .set({
          'email': userEmail,
          'username': userName,
          'user_image': downloadURL,
        });
      }
    } on FirebaseAuthException catch (err) {
      // print('in PlatFormException $err');

      var message = 'something is wrong';

      if (err.message != null) {
        message = FormatError().finalError(err.message.toString());
        setState(() {
          isLoading = false;
        });
        // print(message);
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      print(err.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(
          submit: _submitingAuthForm,
          isLoading: isLoading,
        ));
  }
}
