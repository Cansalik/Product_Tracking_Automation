import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Cubit/Products_Cubit.dart';
import 'package:product_tracking_automation/Services/Products_Services.dart';

class Product_Update_Page extends StatefulWidget {
  const Product_Update_Page({Key? key}) : super(key: key);

  @override
  State<Product_Update_Page> createState() => _Product_Update_PageState();
}

class _Product_Update_PageState extends State<Product_Update_Page> {

  var productRepo = Products_Repositories();
  TextEditingController tfproductPrice = TextEditingController();
  TextEditingController tfproductPiece = TextEditingController();

  late int selectedProductIndex = 0;

  late String productKey;
  late int productPiece = 0;
  late String productPrice = "0";
  late String productImage = "https://firebasestorage.googleapis.com/v0/b/loginproject-f4cac.appspot.com/o/product_images%2FAdd_image.png?alt=media&token=81342a9c-7fea-4581-b4a5-a7596f1ea12f";

  late String selectedProduct = "Lütfen Ürün Seçin";




  @override
  void initState() {
    context.read<Products_Cubit>().productsLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150,),
              Text("Ürün Güncelleme",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SizedBox(width: 250, height: 250, child: Image.network(productImage),),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                        child: Text(selectedProduct,style: TextStyle(color: Colors.white),),
                        onPressed: () => showCupertinoModalPopup
                          (
                          context: context,
                          builder: (_) =>SizedBox(
                            width: double.infinity,
                            height: 250,
                            child: CupertinoPicker(
                              backgroundColor: Colors.white,
                              itemExtent: 60,
                              scrollController: FixedExtentScrollController(
                                initialItem: 1,
                              ),
                              onSelectedItemChanged: (int value) {
                                setState(() {
                                  selectedProductIndex = value;
                                });
                              },
                              children: context.read<Products_Cubit>().productList.map<Widget>((String value) {
                                return GestureDetector(
                                    onTap: ()
                                    {
                                      setState(() {
                                        selectedProduct = value;
                                        Navigator.of(context).pop();
                                        context.read<Products_Cubit>().productLoadForUpdate(selectedProduct).then((productData){
                                          setState(() {
                                            productKey = productData["product_id"].toString();
                                            productPrice = productData["product_price"].toString();
                                            productPiece = int.parse(productData["product_piece"].toString());
                                            productImage = productData["product_image_1"].toString();
                                          });
                                        });
                                      });
                                    },
                                    child: Center(child: Text(value, style: TextStyle(color: Colors.black),)));
                              }).toList(),
                            ),
                          ),
                        )
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      style: TextStyle(color: Colors.white,),
                      controller: tfproductPrice,
                      decoration: customInputDecoration("Ürünün Güncel Fiyatı: $productPrice"),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 25,),
                    TextField(
                      style: TextStyle(color: Colors.white,),
                      controller: tfproductPiece,
                      decoration: customInputDecoration("Ürünün Güncel Adedi: $productPiece"),
                      keyboardType: TextInputType.number,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          child: Text("Ürünü Güncelle",style: TextStyle(color: Colors.pinkAccent,fontSize: 20,fontWeight: FontWeight.bold),),
                          onPressed: ()
                          {
                            context.read<Products_Cubit>().updateProduct(productKey, selectedProduct, tfproductPrice.text, tfproductPiece.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(milliseconds: 1000),
                                backgroundColor: Color(0xff21254A),
                                content: Text("Güncellendi",
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


InputDecoration customInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
  );
}
