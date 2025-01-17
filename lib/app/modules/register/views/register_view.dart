import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
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
                  controller: controller.usernamecontroller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Display Name"
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: controller.passwordcontroller,
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
                    controller.registeraccount();
                  }, child: Text("Register"))
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(onPressed: (){Get.toNamed("/login");}, child: Text("Ada akun ? Login disini !")),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
