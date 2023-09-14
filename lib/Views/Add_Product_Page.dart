import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Cubit/Products_Cubit.dart';

class Add_Product_Page extends StatefulWidget {

  @override
  State<Add_Product_Page> createState() => _Add_Product_PageState();
}

class _Add_Product_PageState extends State<Add_Product_Page> {

  late String barcodeScanRes,producBarcodeCode = "";
  late int product_piece = 0;
  late String key;
  String? product_name = "", product_image_1 = "", product_image_2 = "", product_Piece = "", _key = "";

  Future<void> scanBarcode() async {
    try
    {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
      debugPrint(barcodeScanRes);
      producBarcodeCode = barcodeScanRes;
      context.read<Products_Cubit>().loadProduct(int.parse(barcodeScanRes)).then((productData)
      {
        if(productData.isNotEmpty)
        {
          _key = productData["product_id"];
          product_name = productData["product_name"];
          product_image_1 = productData["product_image_1"];
          product_image_2 = productData["product_image_2"];
          product_Piece = productData["product_piece"];
          product_piece = int.parse(product_Piece.toString());
          key = _key.toString();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sisteme ',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      TextSpan(
                        text: product_name,
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      TextSpan(
                        text: ' Eklensin mi ?',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ],
                  ),
                ),
                content: SizedBox(
                  width: 300,
                  height: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: 135, height: 150, child: Image.network("$product_image_1")),
                            SizedBox(width: 135, height: 150, child: Image.network("$product_image_2")),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Ürün Kodu: ',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            TextSpan(
                              text: producBarcodeCode,
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(child: Text("Hayır"), onPressed: () => Navigator.pop(context)),
                  TextButton(
                    child: Text("Evet"),
                    onPressed: ()
                    {
                      onYesButtonPressed(context, key, product_piece);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Color(0xff21254A),
                          content: Text("Eklendi",
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
        else
        {
          errorShowDialog(context, "HATA! Böyle Bir Ürün Yok");
        }
      });
    }
     catch(e)
    {
      errorShowDialog(context, "Oppps Bir Hata Aldık!");
    }
    if (!mounted) return;
  }

  void onYesButtonPressed(BuildContext context, String producBarcodeCode, int currentPieceValue) {
    // Ürün adedini bir artır
    int newPieceValue = currentPieceValue + 1;

    // Firebase'deki değeri güncelle
    context.read<Products_Cubit>().updateProductPiece(producBarcodeCode, newPieceValue);

    // Dialog'u kapat
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Sisteme Yeni Ürün Ekle",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 26),),
            SizedBox(
              width: 350,
              height: 75,
              child: ElevatedButton(
                  child: Text("Barkod Okumaya Başla",style: TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.bold,fontSize: 24),),
                  onPressed: () {scanBarcode();}
              ),
            ),
          ],
        ),
      ),
    );
  }
}



void errorShowDialog(BuildContext context,errorMessage) {
  showDialog(
      context: context,
      builder: (BuildContext contex)
      {
        return AlertDialog(
          title: Text("HATA",style: TextStyle(color: Colors.red,fontSize: 36),),
          content: Text("$errorMessage",style: TextStyle(fontWeight: FontWeight.bold),),
          actions: [
            TextButton(
              child: Text("Tamam"),
              onPressed: ()
              {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
  );
}
