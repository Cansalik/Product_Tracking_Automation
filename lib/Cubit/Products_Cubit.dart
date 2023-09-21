import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Models/Products.dart';
import 'package:product_tracking_automation/Services/Products_Services.dart';

class Products_Cubit extends Cubit<void> {
  Products_Cubit() : super(0);
  List<String> productList = [];


  var productsRepositories = Products_Repositories();

  Future<int> getAllProductPiece() async {
    return productsRepositories.getAllProductPiece();
  }

  Future<Map<String, String>> loadProduct(int Barcode) async {
    return productsRepositories.loadProduct(Barcode);
  }

  void updateProductPiece(String updateKeyBarcode, int newPieceValue) {
    productsRepositories.updateProductPiece(updateKeyBarcode, newPieceValue);
  }

  Future<void> productsLoad() async {
    FirebaseDatabase.instance.ref().child("Products").onValue.listen((event)
    {
      var getterValues = event.snapshot.value as dynamic;
      if(getterValues!=null)
      {
        getterValues.forEach((key, object)
        {
          var product = Products.fromJson(key, object);
          productList.add(product.product_name);
        });
      }
      else
      {
        print("Load Hata");
      }
    });
  }

  Future<Map<String, String>> productLoadForUpdate(String selectedProductName) async {
    return productsRepositories.productLoadForUpdate(selectedProductName);
  }

  Future<void> updateProduct(String productKey,productName,productPrice,productPiece) async {
    productsRepositories.updateProduct(productKey, productName, productPrice, productPiece);
  }

}