import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talkthrough/screen/controller/FirebaseConst.dart';

import '../NavigationAuthScreen.dart/NavigationAutthScreen.dart';

Future<String> sigIn_controller({required String email,required String password})async {
  String output="Successfully";
  if(email==""&&password=="")return "01";
  else if(email=="")return "0";
  else if(password=="")return "1";
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }on FirebaseAuthException catch(ex){
    output=_getMessageFromErrorCode(ex);
  }
  return output;
}
Future<String> sigUp_controller({required String email,required String password})async {
  String output="Successfully";
  if(email==""&&password=="")return "01";
  else if(email=="")return "0";
  else if(password=="")return "1";
  else if(password.length<=7)return "PassWord length less then 8";
  try{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((signedUser)async {
      await userCollection.doc(signedUser.user!.uid).set({
        "email":email,
        "password" :password,
        "uid":signedUser.user!.uid,
        "username": "user name",
      });
    });
    // .then((signed)
  }on FirebaseAuthException catch(ex){
    output=_getMessageFromErrorCode(ex);
  }
  return output;
}
void logout({required BuildContext context}){
  FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => NavigationAutthScreen(),
    ),
    (route) => false, //if you want to disable back feature set to false
  );
}
 String _getMessageFromErrorCode(FirebaseAuthException exception) {
    switch (exception.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
        break;
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
        break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
        break;
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
        break;
      default:
        return "Login failed. Please try again.";
        break;
    }
  }