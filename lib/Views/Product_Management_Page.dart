import 'package:flutter/material.dart';
import 'package:product_tracking_automation/Views/Add_NewProduct_Page.dart';
import 'package:product_tracking_automation/Views/Add_Product_Page.dart';
import 'package:product_tracking_automation/Views/Homepage_BottomNavigatorBar.dart';
import 'package:product_tracking_automation/Views/Product_Update_Page.dart';
import 'package:product_tracking_automation/Views/Sell_Product_Page.dart';

class Product_Management_Page extends StatefulWidget {
  const Product_Management_Page({Key? key}) : super(key: key);

  @override
  State<Product_Management_Page> createState() => _Product_Management_PageState();
}

class _Product_Management_PageState extends State<Product_Management_Page> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage_BottomNavigationBar()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xff21254A),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 150,),
                Text("Ürün İşlemleri",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top:18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Add_NewProduct_Page()));
                      },
                          child: CustomCard(text: "Yeni Ürün Kaydet", imagePath: "assets/images/New_clothes.png")),
                      GestureDetector(
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Add_Product_Page()));
                          },
                          child: CustomCard(text: "Sisteme Ürün Ekle", imagePath: "assets/images/Add_clothes.png")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Sell_Product_Page()));
                          },
                          child: CustomCard(text: "Ürün Sat", imagePath: "assets/images/Sell_shirt.png")),
                      GestureDetector(
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Product_Update_Page()));
                          },
                          child: CustomCard(text: "Ürün Bilgi Güncelle", imagePath: "assets/images/Add_category.png")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String imagePath;
  final String text;

  CustomCard({required this.imagePath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Card(
        elevation: 4.0,
        child: Container(
          width: 150.0,
          height: 150.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                imagePath,
                width: 80.0,
                height: 80.0,
              ),
              SizedBox(height: 8.0),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


