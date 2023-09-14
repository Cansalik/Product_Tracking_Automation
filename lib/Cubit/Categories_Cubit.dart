import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Repositories/Categories_Repositories.dart';

class Categories_Cubit extends Cubit<void>
{
  Categories_Cubit(): super(0);

  var categori = Categories_Repositories();
  List<String> categoryList = [];


  Future<void> categoryLoad() async {
    categori.categoryLoad();
    categori.categoryList = categoryList;
  }

}