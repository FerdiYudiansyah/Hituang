import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.displaynamecontroller.text=controller.auth.currentUser!.displayName.toString();
    controller.datetimecontroller.text= DateTime.now().toString();
    final pages=
    [
      Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  color: Colors.transparent,
                  child: ListTile(
                    isThreeLine: false,
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx((){
                        return Text("Rp.${controller.formatMoney((controller.uangkeluar.value+controller.uangmasuk.value).toString())}",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),);
                      })
                    ),
                  )
              ),
              Container(
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(20),bottomLeft:Radius.circular(20))
                          )
                        ),
                        child: ListTile(
                          isThreeLine: false,
                          
                          leading: Icon(Icons.arrow_upward_rounded,size: 30,color: Colors.white,),
                          title:  SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Obx((){
                              return Text("Rp.${controller.formatMoney(controller.uangmasuk.value.toString()).toString()}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black));
                              }
                            ),
                          ),
                        ),
                      )
                    ),
                    Flexible(
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topRight:Radius.circular(20),bottomRight:Radius.circular(20))
                          )
                        ),
                        child: ListTile(
                          
                          leading: Icon(Icons.arrow_downward_rounded,size: 30,color: Colors.white,),
                          title:  SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Obx((){
                              return Text("Rp. ${controller.formatMoney(controller.uangkeluar.value.toString()).toString()}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),);
                            }),
                          )
                        ),
                      )
                    )
                  ],
                )
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<List<FlSpot>>(
                  future: controller.fetchChartData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container();
                    }
                    return Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              show: true,
                              spots: snapshot.data!, // Use fetched data
                              color: Colors.blueAccent,
                              barWidth: 5,
                            ),
                          ],
                        ),
                      ),
                      )
                    );
                  },
                ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('transaksi')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('transaksi').orderBy('datetime',descending: true)
                    .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No transactions found."));
                    }
                    var uangmasuk = 0.0;
                    var uangkeluar = 0.0;
                    
                    for (var doc in snapshot.data!.docs) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      if (data['total'] > 0) {
                        uangmasuk += data['total'];
                      } else if (data['total'] < 0) {
                        uangkeluar += data['total'];
                      }
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.uangmasuk.value = uangmasuk;
                      controller.uangkeluar.value = uangkeluar;
                      controller.uangtotal.value = uangmasuk - uangkeluar;
					            controller.fetchChartData();
                      controller.fetchBarChartData();
                    });

                    return ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data!.docs[index];
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        var isPositive=false;
                        if (data['total'] > 0) {
                          isPositive = true;
                        } else if (data['total'] < 0) {
                          isPositive = false;
                        }
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(8, 146, 146, 146).withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Theme(
                            data: ThemeData().copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                              leading: isPositive ?
                                CircleAvatar(
                                  backgroundColor: Colors.greenAccent,
                                  child: Icon(Icons.arrow_upward_rounded,color: Colors.white,weight: 50,)
                                )
                                :
                                CircleAvatar(
                                  backgroundColor: Colors.redAccent,
                                  child: Icon(Icons.arrow_downward_rounded,color: Colors.white,)
                                ),
                                
                              title: Text(
                                (data['nama'] ?? 'Anonym').toString().capitalize!+'\n${"Rp."+controller.formatMoney(data['total'].toString())}',
                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)
                              ),
                              subtitle: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    SizedBox(width: 5,),
                                    Text(
                                      '${data['datetime']!}' ?? 'No Date',
                                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        Get.toNamed("/edit",arguments: [doc.id,data['nama'],data['keperluan'],data['datetime'],data['total']]);
                                      },
                                      child: Icon(Icons.edit),
                                      style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                          CircleBorder()
                                        )
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: (){
                                        Get.defaultDialog(
                                          title: "Apakah anda yakin?",
                                          middleText: "Jadi untuk hapus transaksi ini?",
                                          contentPadding: EdgeInsets.all(20),
                                          textConfirm: "Ya, Hapus",
                                          textCancel: "Batal",
                                          onConfirm: () async {
                                            controller.deleteTransaction(doc.id);
                                            controller.fetchChartData();
                                            controller.fetchBarChartData();
                                            Get.back(closeOverlays: true);
                                          }
                                        );
                                      },
                                      child: Icon(Icons.delete),
                                      style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                          CircleBorder()
                                        )
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16.0);
                      },
                    );
                  }
                )
              ),
            ],
          )
        )
      ),
      Container(
        padding: EdgeInsets.all(50),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.\-]')),
                  ],
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
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(controller.moneyformatted.string,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)
                  );
                }),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){controller.addTransaction();},
                    child: Text("Tambahkan Transaksi")
                  )
                )
              ],
            ),
          )
        )
      ),
      Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<List<FlSpot>>(
                  future: controller.fetchChartData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container();
                    }
                    return Expanded(
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              show: true,
                              spots: snapshot.data!,
                              color: Colors.blueAccent,
                              barWidth: 5,
                            ),
                          ],
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              FutureBuilder<List<BarChartGroupData>>(
                future: controller.fetchBarChartData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container();
                  }

                  return Expanded(
                    child: BarChart(
                      BarChartData(
                        barGroups: snapshot.data!,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value,meta) => Text(value.toString()),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value,meta) => Text('Day ${value.toInt()}'),
                            ),
                          )
                          
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                      ),
                    ),
                  );
                },
              ),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('transaksi')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('transaksi').orderBy('datetime',descending: true)
                    .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No transactions found."));
                    }
                    var uangmasuk = 0.0;
                    var uangkeluar = 0.0;
                    
                    for (var doc in snapshot.data!.docs) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      if (data['total'] > 0) {
                        uangmasuk += data['total'];
                      } else if (data['total'] < 0) {
                        uangkeluar += data['total'];
                      }
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.uangmasuk.value = uangmasuk;
                      controller.uangkeluar.value = uangkeluar;
                      controller.uangtotal.value = uangmasuk - uangkeluar;
                      controller.fetchChartData();
                      controller.fetchBarChartData();
                    });
                    return Container();
                  }
                )
              ),
            ],
          )
        )
      ),
      Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Stack(
              children: [
                CircleAvatar(
                    minRadius: 100,
                    maxRadius: 100,
                    backgroundImage: NetworkImage(controller.auth!.currentUser!.photoURL.toString())
                ),
                Positioned(
                  right: 0,
                  child: Obx((){
                    if (controller.editingprofile.value==true){
                      return ElevatedButton(
                        onPressed: (){
                          controller.choosepfp();
                        },
                        style: ButtonStyle(shape: WidgetStateProperty.all<CircleBorder>(CircleBorder())), 
                        child: Icon(Icons.edit,size: 30,)
                      );
                    }
                    else{
                      return Container();
                    }  
                  })
                ),
              ],
            ),
            ElevatedButton(
              onPressed: (){
                controller.editprofile();
              },
              child: Text("Edit Profil")
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: 
                  Obx((){
                    return TextFormField(
                      enabled: controller.editingprofile.value,
                      controller: controller.displaynamecontroller,
                      decoration: InputDecoration(
                        hintText: "Display Name"
                      ),
                    );}
                  )
                ),
              ],
            ),
            Obx((){
              if (controller.editingprofile.value==true){
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      controller.saveprofile();
                      print("hi");
                    },
                    child: (
                      Text("Simpan Profil")
                    )
                  )
                );
              }
              else{
                return Container();
              }
            }),
            ListTile(
              title: Text("Log Out"),
              leading: Icon(Icons.logout),
              onTap: (){
                Get.defaultDialog(
                  title: "Log Out",
                  content: Text("Apakah anda yakin?"),
                  textCancel: "Batal",
                  textConfirm: "Ya, Log Out",
                  onConfirm: () {
                    controller.logOut();
                  }
                );
              },
            ),
          ],
        )
      )
    ];
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color.fromARGB(255, 0, 23, 59),
        backgroundColor: Colors.transparent,
        items: <Widget>[
          Icon(Icons.home,size: 30,color: Colors.yellow),
          Icon(Icons.add,size: 30,color: Colors.yellow),
          Icon(Icons.bar_chart,size: 30,color: Colors.yellow),
          Icon(Icons.person,size: 30,color: Colors.yellow),
        ],
        onTap: (index){
          controller.tabidx.value=index;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body:
      Obx((){
        return pages[controller.tabidx.value];
      })
    );
  }
}
