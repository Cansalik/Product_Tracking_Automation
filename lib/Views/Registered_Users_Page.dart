import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Cubit/Users_Cubit.dart';

class Registered_Users_Page extends StatefulWidget {
  const Registered_Users_Page({Key? key}) : super(key: key);

  @override
  State<Registered_Users_Page> createState() => _Registered_Users_PageState();
}

class _Registered_Users_PageState extends State<Registered_Users_Page> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Tüm Kullanıcılar",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        flexibleSpace: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color.fromRGBO(33, 37, 74, 1),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(33, 37, 74, 1),
        ),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('users').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Veri yükleniyor göstergesi
            } else if (snapshot.hasError) {
              return Text('Hata: ${snapshot.error}');
            } else {
              final users = snapshot.data!.docs;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final userData = users[index].data() as Map<String, dynamic>;
                  final name = userData['name'];
                  final email = userData['email'];
                  final phone = userData['phone'];
                  final photo = userData['photo'];
                  return Card(
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SizedBox(width: 80, height: 80, child: Image.network(photo)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:10.0,top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                Text(email,style: TextStyle(fontSize: 16,color: Colors.blue),),
                                Text(phone,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
