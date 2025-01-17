import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  var emailcontroller = TextEditingController();
  var usernamecontroller =TextEditingController();
  var passwordcontroller = TextEditingController();

  void registeraccount() async{
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailcontroller.text,
      password: passwordcontroller.text,
    ).then((newUser) {
      auth.currentUser?.updateDisplayName(usernamecontroller.text);
    });
    await auth.currentUser?.sendEmailVerification();
    Get.snackbar("Sukses!", "Akun anda sudah sukses dibuat!, cek email untuk verifikasi");
    Get.offNamed("/login");
  } on FirebaseAuthException catch (e) {
    SnackBar(content: Text(e.toString()));
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      Get.snackbar("Yah Gagal...", "Passwordnya terlalu lemah, Minimal 6 huruf !");
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      Get.snackbar("Yah Gagal...", "Akun Emailnya sudah Terdaftar!");
    }
  } catch (e) {
    Get.snackbar("Yah Gagal...", "Ada yang eror nih");
  }
  }
}