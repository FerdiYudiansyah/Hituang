import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50),
        child:
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: controller.emailcontroller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Email"
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: controller.passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    hintText: "Password"
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){
                    controller.login(controller.emailcontroller.text,controller.passwordcontroller.text);
                  }, child: Text("Login"))
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Image.network("https://lh3.googleusercontent.com/COxitqgJr1sJnIDe8-jiKhxDx1FrYbtRHKJ9z_hELisAlapwE9LUPh6fcXIfb5vwpbMl4xl9H9TRFPc5NOO8Sb3VSgIBrfRYvW6cUA",scale: 20,),
                    onPressed: (){
                    controller.signInWithGoogle();
                  }, label: Text("Login With Google"),
                  )
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: (){
                      Get.offNamed("/register");
                    }, 
                    child: Text("Tidak ada akun? Register disini !")
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
