import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Models/Products.dart';

class Products_List_Cubit extends Cubit<List<Products>>
{
  Products_List_Cubit() : super(<Products>[]);

  var refProducts = FirebaseDatabase.instance.ref().child("Products");

  Future<void> AllProductsLoad() async {
    refProducts.onValue.listen((event)
    {
      var getterValues = event.snapshot.value as dynamic;

      if(getterValues!=null)
      {
        var list = <Products>[];
        getterValues.forEach((key, object)
        {
          var _product = Products.fromJson(key, object);
          list.add(_product);
        });
        emit(list);
      }
    });
  }
}