import 'package:firebase_database/firebase_database.dart';
import 'package:product_tracking_automation/Models/Categories.dart';

class Categories_Repositories
{
  var _firebaseCategory = FirebaseDatabase.instance.ref().child("Categories");
  List<String> categoryList = [];

  Future<void> categoryLoad() async {
    _firebaseCategory.onValue.listen((event)
    {
      var getterValues = event.snapshot.value as dynamic;
      if(getterValues!=null)
      {
        getterValues.forEach((key, object)
        {
          var category = Categories.fromJson(key, object);
          categoryList.add(category.categori_name);
        });
      }
      else
      {
        print("Load Hata");
      }
    });
  }
}