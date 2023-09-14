import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:product_tracking_automation/Entity/Categories.dart';
import 'package:product_tracking_automation/Entity/Products.dart';

class Product_With_Categories_Page extends StatefulWidget {
  Categories categories;

  Product_With_Categories_Page({ required this.categories});

  @override
  _Product_With_Categories_PageState createState() => _Product_With_Categories_PageState();
}

class _Product_With_Categories_PageState extends State<Product_With_Categories_Page> {

  var refProducts = FirebaseDatabase.instance.ref().child("Products");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff21254A),
        title: Text("${widget.categories.categori_name}",style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff21254A),
        ),
        child: StreamBuilder<DatabaseEvent>(
          stream: refProducts.orderByChild("categori_name").equalTo(widget.categories.categori_name).onValue,
          builder: (context,event){
            if(event.hasData){
              var productList = <Products>[];
              var inValues = event.data!.snapshot.value as dynamic;
              if(inValues!=null)
              {
                inValues.forEach((key, object)
                {
                  var inProduct = Products.fromJson(key, object);
                  productList.add(inProduct);
                });
              }
              return Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 5.5,
                  ),
                  itemCount: productList!.length,
                  itemBuilder: (context,indeks){
                    var _product = productList[indeks];
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 250,
                              height: 250,
                              child: Image.network(
                                _product.product_image_1,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text("${_product.product_name}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black),),
                          Text("Barkod: ${_product.product_barcode}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black),),
                          Text("Toplam: ${_product.product_piece.toString()} adet",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black),),
                        ],
                      ),
                    );
                  },
                ),
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
