import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class EditController extends GetxController {
  var firestore = FirebaseFirestore.instance;
  var docid = Get.arguments[0];
  var fish = "a";
   void onInit() {
    print(Get.arguments);
    setEditor();
    super.onInit();
  }
  
  var namatransaksicontroller = TextEditingController();
  var keperluantransaksicontroller = TextEditingController();
  var datetimecontroller = TextEditingController();
  var totalcontroller = TextEditingController();

  var moneyformatted = "".obs;

  formatMoney(money){
    MoneyFormatter fmf = MoneyFormatter(amount: double.tryParse(money)??0);
    return fmf.output.nonSymbol;
  }

  void pickdatetime() async{
    DateTime? dateTime = await showOmniDateTimePicker(context: Get.context!);
    print(dateTime);
    datetimecontroller.text = dateTime.toString();
  }

  void editTransaction(){
    Get.defaultDialog(
      title: "Apakah anda yakin?",
      middleText: "Jadi untuk ubah transaksi ini?",
      contentPadding: EdgeInsets.all(20),
      textConfirm: "Ubah",
      textCancel: "Batal",
      onConfirm: (){
        edittransctiontocloud();
      }
    );
  }

  void setEditor(){
    namatransaksicontroller.text = Get.arguments[1];
    keperluantransaksicontroller.text = Get.arguments[2];
    datetimecontroller.text = Get.arguments[3];
    totalcontroller.text = Get.arguments[4].toString();
  }

  void edittransctiontocloud() async{
    try{
      print(docid);
      print("tst");
        await firestore
        .collection('transaksi')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('transaksi')
        .doc(docid)
        .update({'nama': namatransaksicontroller.text, 'keperluan':keperluantransaksicontroller.text,'total': double.parse(totalcontroller.text) , 'datetime':datetimecontroller.text});
      Get.snackbar('Sukses', 'Transaksi sudah diubah');
      Get.offAllNamed("/home");
    }
    catch(e){
      print("Eror");
      print("Eror"+e.toString());
    }
  }
}
