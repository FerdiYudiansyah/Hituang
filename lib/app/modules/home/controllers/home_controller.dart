import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  var tabidx = 0.obs;
  
  var displaynamecontroller = TextEditingController();
  var Displaynametoggle = false.obs;
  var username = "".obs;
  var firestore = FirebaseFirestore.instance;
  var uangmasuk = 0.0.obs;
  var uangkeluar = 0.0.obs;
  var uangtotal = 0.0.obs;

  var refreshtracker = false.obs;
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    Get.snackbar("Sukses!","Sukses Log Out");
  }

  void listenToUserTransactions() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('transaksi')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print("Real-time Transaction: ${doc.data()}");
      }
    });
  }

  formatMoney(money){
    MoneyFormatter fmf = MoneyFormatter(amount: double.tryParse(money)??0);
    return fmf.output.nonSymbol;
  }

  getUserInfo(){
    var Info = [
      auth.currentUser!.displayName,
      auth.currentUser!.photoURL,
    ];
    return Info;
  }

  void pickImagefromgallery() async{
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  }
  void deleteTransaction(docid) async{
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var querySnapshot = await firestore.collection('transaksi')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('transaksi').get();
    for (var doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('transaksi')
          .doc(userId)
          .collection('transaksi')
          .doc(docid)
          .delete();
    }
  }

  Future<List<FlSpot>> fetchChartData() async {
    QuerySnapshot snapshot = await firestore.collection('transaksi')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('transaksi').orderBy('datetime',descending: true).get();
    List<FlSpot> spots = [];
    try{
       for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('datetime') && data['datetime'] is String) {

          DateTime dateTime = DateTime.parse(data['datetime']);

          double x = dateTime.day.toDouble();

          double y = (data['total'] as num).toDouble();

          spots.add(FlSpot(x, y));
        }
      }
    }
    catch(e){
    }
    return spots;
  }
  Future<List<BarChartGroupData>> fetchBarChartData() async {
    QuerySnapshot snapshot = await firestore.collection('transaksi')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('transaksi')
        .orderBy('datetime', descending: false)
        .get();

    Map<int, double> dayTotals = {};
    List<BarChartGroupData> barChartData = [];
    try{
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('datetime') && data['datetime'] is String) {
          DateTime dateTime = DateTime.parse(data['datetime']);
          int day = dateTime.day;

          double total = (data['total'] as num).toDouble();

          if (dayTotals.containsKey(day)) {
            dayTotals[day] = dayTotals[day]! + total;
          } else {
            dayTotals[day] = total;
          }
        }
      };
        dayTotals.forEach((day, total) {
        barChartData.add(
          BarChartGroupData(
            x: day,
            barRods: [
              BarChartRodData(
                toY: total, 
                color: Colors.blue,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      });
    }
    catch(e){

    }
    return barChartData;
  }

  //CreatePage

  var namatransaksicontroller = TextEditingController();
  var keperluantransaksicontroller = TextEditingController();
  var datetimecontroller = TextEditingController();
  var totalcontroller = TextEditingController();

  var moneyformatted = "".obs;

  void pickdatetime() async{
    DateTime? dateTime = await showOmniDateTimePicker(context: Get.context!);
    datetimecontroller.text = dateTime.toString();
  }

  void addTransaction(){
    Get.defaultDialog(
      title: "Apakah anda yakin?",
      middleText: "Jadi untuk nambah transaksi ini?",
      contentPadding: EdgeInsets.all(20),
      textConfirm: "Tambahkan",
      textCancel: "Batal",
      onConfirm: (){
        addtransctiontocloud();
      }
    );
  }
  void addtransctiontocloud() async{
    try{
        await firestore
        .collection('transaksi')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('transaksi')
        .add({'nama': namatransaksicontroller.text, 'keperluan':keperluantransaksicontroller.text,'total': double.parse(totalcontroller.text) , 'datetime':datetimecontroller.text});
      Get.snackbar('Sukses', 'Transaksi telah ditambahkan');
      Get.offAllNamed("/home");
    }
    catch(e){
    }
  }

  //Profile Page
  var editingprofile = false.obs;
  var changeprofilelink = FirebaseAuth.instance.currentUser!.photoURL.obs;
  editprofile(){
    if (editingprofile.value==true){
      editingprofile.value = false;
    }
    else{
      editingprofile.value = true;
    }
    displaynamecontroller.text=auth.currentUser!.displayName.toString();
  }

  choosepfp() async{
    try{
        var photolist=[];
        var snapshot = await firestore
            .collection('profilephotos')
            .doc('tDrmABk6CATT4ctCNnNR')
            .get().then((links){
              for (String link in links['link']){
                photolist.add(link.toString());
              }
            });
        Get.dialog(
        barrierDismissible: true,
        Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 300,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      for (var link in photolist)
                      IconButton(
                        onPressed: (){
                          changeprofilelink.value =  link;
                        },
                        icon: Image.network(link),
                      ),
                    ],
                  )
                )
              ],
            )
          )
        )
      );
        
    }
    catch(e){

    }
  }

  saveprofile(){
    try{
      auth.currentUser?.updateProfile(
      displayName: displaynamecontroller.text,
      photoURL: changeprofilelink.value,
      );
      editingprofile.value=false;
      Get.snackbar("Sukses", "Sukses mengubah profile");
    }
    catch(e){
      Get.snackbar("Eror", "Gagal mengubah profile");
    }
    
  }
}
