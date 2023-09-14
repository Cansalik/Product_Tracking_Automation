import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Cubit/Categories_List_Cubit.dart';
import 'package:product_tracking_automation/Cubit/Products_Cubit.dart';
import 'package:product_tracking_automation/Entity/Categories.dart';
import 'package:product_tracking_automation/Entity/Users.dart';
import 'package:product_tracking_automation/Views/Homepage_BottomNavigatorBar.dart';
import 'package:product_tracking_automation/Views/Product_With_Categories_Page.dart';

class Categories_Page extends StatefulWidget {
  const Categories_Page({Key? key}) : super(key: key);

  @override
  State<Categories_Page> createState() => _Categories_PageState();
}

class _Categories_PageState extends State<Categories_Page> {

  @override
  void initState() {
    context.read<Categories_List_Cubit>().categoriesLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage_BottomNavigationBar()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(33, 37, 74, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(33, 37, 74, 1),
          leading: Container(),
          title: Text("Lütfen Kategori Seçin",style: TextStyle(color: Colors.white,),),
        ),
        body: BlocBuilder<Categories_List_Cubit,List<Categories>>(
            builder: (context, categoriesList)
            {
              if(categoriesList.isNotEmpty)
              {
                return ListView.builder(
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index)
                  {
                    var category = categoriesList[index];
                    return GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Product_With_Categories_Page(categories: category)));
                      },
                      child: Card(
                        child: SizedBox(
                          height: 75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(category.categori_name,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(width:50,height:50,child: Image.asset("assets/images/${category.categori_image}.png")),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              else
              {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Yükleniyor...",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                    ],
                  ),
                );
              }
            }
        ),
      ),
    );
  }
}
