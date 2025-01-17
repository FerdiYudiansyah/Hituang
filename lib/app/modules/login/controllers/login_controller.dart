import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  
  FirebaseAuth auth = FirebaseAuth.instance;

  void login(emailAddress,password) async{
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password
      );
      if (auth.currentUser!.emailVerified==true){
        print("logging in");
        Get.offNamed("/home");
      }
      else{
        Get.snackbar("Verifikasi", "Verifikasi akun email terlebih dahulu, cek inbox anda");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        SnackBar(content: Text("No user found for that email.",));

      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        SnackBar(content: Text("Wrong password provided for that user.",));
      }
    }
  }


  signInWithGoogle() async {
    try{
        // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    catch(e){
      
    }
    
  }

  @override
  void onInit(){
    super.onInit;
    checkauth();
  }

  void checkauth(){
    auth.authStateChanges()
    .listen((User? user) {
     if (user == null) {
        Get.toNamed("/login");
        Get.snackbar("Login !", "Login Dahulu!");
     } else {
       var username = auth.currentUser!.displayName;
       if (user.emailVerified==true){
        print(user.emailVerified);
        print("im here");
        Get.snackbar("Hi User", "Hi User $username");
        Get.offNamed("/home");
       }
       else{
        Get.snackbar("Verifikasi", "Verifikasi akun email terlebih dahulu, cek inbox anda");
       }
     }
    });
  }
}
