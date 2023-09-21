import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Models/Categories.dart';

class Categories_List_Cubit extends Cubit<List<Categories>>
{
  Categories_List_Cubit() : super(<Categories>[]);


  var refCategory = FirebaseDatabase.instance.ref().child("Categories");

  Future<void> categoriesLoad() async
  {
    refCategory.onValue.listen((event)
    {
      var getterValues = event.snapshot.value as dynamic;

      if(getterValues!=null)
      {
        var list = <Categories>[];
        getterValues.forEach((key, object)
        {
          var _category = Categories.fromJson(key, object);
          list.add(_category);
        });
        emit(list);
      }
    });
  }

}