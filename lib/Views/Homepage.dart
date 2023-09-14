import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:product_tracking_automation/Cubit/Products_Cubit.dart';
import 'package:product_tracking_automation/Cubit/Users_Cubit.dart';
import 'package:product_tracking_automation/Views/All_Products_Page.dart';
import 'package:product_tracking_automation/Views/Login_Page.dart';
import 'package:product_tracking_automation/Views/My_Account_Page.dart';
import 'package:product_tracking_automation/Views/Registered_Users_Page.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  String? name = "",_photo = "";
  late int totalProductPiece = 0;
  final List<String> imageList = ["https://kurumsal.boyner.com.tr/images/contentimages/images/magaza2b.jpg", "https://kurumsal.boyner.com.tr/images/contentimages/images/magaza3b.jpg", "https://kurumsal.boyner.com.tr/images/contentimages/images/magaza4b.jpg", "https://kurumsal.boyner.com.tr/images/contentimages/images/magaza5b.jpg"];


  Future<void> _totalProductPiece() async {
    context.read<Products_Cubit>().getAllProductPiece().then((int _totalProductPiece) {
      setState(() {
        totalProductPiece = _totalProductPiece;
      });
    });
  }

  Future<void> _userData() async{
  context.read<Users_Cubit>().getDataFromDatabase().then((userData) {
    setState(() {
      name = userData["name"];
      _photo = userData["photo"];
    });
  });
}

  void initState() {
    setState(() {
      _totalProductPiece();
      _userData();
    });
    super.initState();
  }

    @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<Users_Cubit>().signOut();
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff21254A),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff21254A),
          title: const Text("Anasayfa",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),
          ),
          actions: [
            IconButton(
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => My_Account_Page()));
              },
              icon: Image.network("$_photo"),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Color(0xff21254A),
          child: ListView(
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text("New Piroz Tekstil",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                accountEmail: Text("https://www.newpiroz.com",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/images/Account_settings.png",),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Drawer_background.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.grid_3x3_outlined,color: Colors.white,),
                title: Text("Tüm Ürünler",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => All_Products_Page()));},
              ),
              ListTile(
                leading: Icon(Icons.people,color: Colors.white,),
                title: Text("Kayıtlı Kullanıcılar",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Registered_Users_Page()));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app,color: Colors.white,),
                title: Text("Çıkış Yap",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                onTap: () {
                  context.read<Users_Cubit>().signOut();
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Merhaba, \n New Piroz'a Hoşgeldin",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$name",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                ],
              ),
              SizedBox(height: 50,),
              CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                ),
                items: imageList.map((e) => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(e, fit: BoxFit.cover,),
                    ],
                  ),
                )).toList(),
              ),
              SizedBox(height: 50,),
              Text("Toplam Ürün Adedi: "+ NumberFormat.decimalPattern().format(totalProductPiece).toString() ,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}
