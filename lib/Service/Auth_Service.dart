import 'dart:convert';

import 'package:easy_cook/models/login/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> googleSigIn(BuildContext context) async {
    try {
      print("pok111111");
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        print("pok222222");
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try {
          print("pok33333");
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
              print(userCredential.user.uid);
              print("Login Google success");

            return userCredential;
        } catch (e) {
          print("pok44444");
          print("Login Google Fail");
          return null;
        }
      } else {
        print("pok555555");
        print("Login Google Fail");
        return null;
      }
    } catch (e) {
      print("pok66666");
      print("Login Google Fail");
      return null;
    }
  }

  Future logout() async{
    _googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
  // void LoginFacebookMD(
  //     String userID, email, alias_name, name_surname, profile_image) async {
  //   await loginFacebooks(
  //       userID, email, alias_name, name_surname, profile_image);
  //   print("loginFacebook.success => ${loginFacebook.success}");
  //   SharedPreferences preferences = await SharedPreferences.getInstance();

   
  //   preferences.setString("tokens", loginFacebook.token);
  //   preferences.setString("email", email);

  
  // }
}

 

// LoginModel loginFacebook;
// Future<Null> loginFacebooks(
//       String userID, email, alias_name, name_surname, profile_image) async {
//     final String apiUrl =
//         "http://apifood.comsciproject.com/pjUsers/loginFacebook";

//     var data = {
//       "userID": userID,
//       "email": email,
//       "name_surname": alias_name,
//       "alias_name": name_surname,
//       "profile_image": profile_image
//     };

//     print(jsonEncode(data));

//     final response = await http.post(Uri.parse(apiUrl),
//         body: jsonEncode(data), headers: {"Content-Type": "application/json"});

//     if (response.statusCode == 200) {
//       final String responseString = response.body;
//       print("responseStringFacebook => $responseString");
//       loginFacebook = loginModelFromJson(responseString);
//     } else {
//       return null;
//     }
//   }