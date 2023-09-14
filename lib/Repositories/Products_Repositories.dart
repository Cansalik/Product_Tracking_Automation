import 'package:firebase_database/firebase_database.dart';
class Products_Repositories
{
  final refDatabase = FirebaseDatabase.instance;
  var refDatabaseProduct= FirebaseDatabase.instance.ref().child("Products");
  late int totalProductPiece = 0;

  Future<int> getAllProductPiece() async {
    int totalProductPiece = 0;

    try {
      final event = await refDatabase.ref().child("Products").once();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> products = event.snapshot.value as dynamic;
        products.forEach((key, value) {
          if (value["product_piece"] != null) {
            totalProductPiece += int.parse(value["product_piece"].toString());
          }
        });
      }

      return totalProductPiece;
    } catch (error) {
      print("Hata: $error");
      throw error; // Hata durumunda hata fırlatılabilir
    }
  }

  Future<Map<String, String>> loadProduct(int Barcode) async {
    Map<String, String> productData = {};
    try {
      // Belirli bir barkoda sahip ürünü filtreleyerek çekme
      DatabaseEvent event = await refDatabaseProduct.orderByChild("product_barcode").equalTo(Barcode).once();
      if (event.snapshot.value!= null)
      {
        Map<dynamic, dynamic> values = event.snapshot.value as dynamic;
        values.forEach((key, value) {
          productData["product_id"] = key;
          productData["product_name"] = value["product_name"].toString();
          productData["product_image_1"] = value["product_image_1"].toString();
          productData["product_image_2"] = value["product_image_2"].toString();
          productData["product_piece"] = value["product_piece"].toString();
        });
      }
      else
      {

      }
    } catch (error) {
      // errorShowDialog(context, "Opps! Bir hata aldık :) Tekrar Dene");
    }
    return productData;
  }

  void updateProductPiece(String updateKeyBarcode, int newPieceValue) {
    try {
      // Ürünün anahtarını kullanarak veriyi güncelle
      var bilgi = Map<String, dynamic>();
      bilgi["product_piece"] = newPieceValue;
      refDatabaseProduct.child(updateKeyBarcode).update(bilgi);

    } catch (error) {
      print("Ürün adedi güncelleme hatası: $error");
    }
  }

  Future<Map<String, String>> productLoadForUpdate(String selectedProductName) async {
    Map<String, String> productData = {};
    DatabaseEvent event = await refDatabaseProduct.orderByChild("product_name").equalTo(selectedProductName).once();
    if (event.snapshot.value!= null)
    {
      Map<dynamic, dynamic> values = event.snapshot.value as dynamic;
      values.forEach((key, value) {
        productData["product_id"] = key;
        productData["product_image_1"] = value["product_image_1"].toString();
        productData["product_piece"] = value["product_piece"].toString();
        productData["product_price"] = value["product_price"].toString();
      });
    }
    return productData;
  }

  Future<void> updateProduct(String productKey,productName,productPrice,productPiece) async {
    DatabaseEvent event = await refDatabaseProduct.orderByChild("product_name").equalTo(productName).once();
    try
    {
      if (event.snapshot.value!= null) {
        Map<dynamic, dynamic> values = event.snapshot.value as dynamic;
        values.forEach((key, value) {
          productKey = key;
        });
      }
      var bilgi = Map<String, dynamic>();
      bilgi["product_price"] = productPrice;
      bilgi["product_piece"] = int.parse(productPiece);
      refDatabaseProduct.child(productKey).update(bilgi);
    }
    catch (e)
    {
      print(e.toString());
    }
  }

}