import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Cubit/Products_Cubit.dart';
import 'package:product_tracking_automation/Cubit/Products_List_Cubit.dart';
import 'package:product_tracking_automation/Entity/Products.dart';

class All_Products_Page extends StatefulWidget {

  @override
  State<All_Products_Page> createState() => _All_Products_PageState();
}

class _All_Products_PageState extends State<All_Products_Page> {

  @override
  void initState() {
    context.read<Products_List_Cubit>().AllProductsLoad();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff21254A),
        title: Text("Tüm Ürünler",style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff21254A),
        ),
        child: BlocBuilder<Products_List_Cubit, List<Products>>(
          builder: (context,productsList){
            if(productsList.isNotEmpty){
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3.5,
                ),
                itemCount: productsList.length,
                itemBuilder: (context,indeks){
                  var _product = productsList[indeks];
                  return Card(
                    color: Color(0xff21254A),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            _product.product_image_1,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(_product.product_name,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),),
                      ],
                    ),
                  );
                },
              );
            }else{
              return Center();
            }
          },
        ),
      ),

    );
  }
}

