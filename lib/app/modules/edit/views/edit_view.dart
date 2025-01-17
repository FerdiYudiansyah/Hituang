import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_controller.dart';

class EditView extends GetView<EditController> {
  const EditView({super.key});
  @override
  Widget build(BuildContext context) {
    dynamic docid = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditView'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                  controller: controller.namatransaksicontroller,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Text is empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Nama Transaksi",
                    icon: Icon(Icons.assignment)
                  ),
                ),
                TextFormField(
                  controller: controller.keperluantransaksicontroller,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Text is empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Keperluan",
                    icon: Icon(Icons.business)
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child:
                        TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.datetime,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Text is empty';
                            }
                            return null;
                          },
                          onTap: (){
                            controller.pickdatetime();
                          },
                          controller: controller.datetimecontroller,
                          decoration: InputDecoration(
                            icon: Icon(Icons.date_range),
                            hintText: "Waktu dan Tanggal",
                          )
                        ),
                    )
                  ],
                ),
                TextFormField(
                  controller: controller.totalcontroller,
                  keyboardType: TextInputType.number,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Text is empty';
                    }
                    return null;
                  },
                  onChanged: (text){
                    controller.moneyformatted.value=controller.formatMoney(text);
                  },
                  decoration: InputDecoration(
                    hintText: "Total Harga",
                    icon: Icon(Icons.money)
                  ),
              ),
              Obx((){
                return Text(controller.moneyformatted.string);
              }),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){controller.editTransaction();},
                  child: Text("Ubah Transaksi")
                )
              )
            ],
          )
        )
      ),
    );
  }
}
