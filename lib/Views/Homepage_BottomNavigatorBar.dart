import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Cubit/Users_Cubit.dart';
import 'package:product_tracking_automation/Views/Categories_Page.dart';
import 'package:product_tracking_automation/Views/Homepage.dart';
import 'package:product_tracking_automation/Views/Product_Management_Page.dart';

class Homepage_BottomNavigationBar extends StatefulWidget {
  const Homepage_BottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<Homepage_BottomNavigationBar> createState() => _Homepage_BottomNavigationBarState();
}

class _Homepage_BottomNavigationBarState extends State<Homepage_BottomNavigationBar> {

  var pageList = [Homepage() ,Categories_Page(), Product_Management_Page()];
  late int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async
      {
        context.read<Users_Cubit>().signOut();
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: pageList[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Anasayfa",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: "Ürün Kategorileri",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_applications),
              label: "Ürün İşlemleri",
            ),
          ],
          backgroundColor: Color(0xff21254A),
          selectedItemColor: Colors.pinkAccent,
          unselectedItemColor: Colors.white,
          currentIndex: selectedIndex,
          onTap: (indeks)
          {
            setState(() {
              selectedIndex = indeks;
            });
          },
        ),
      ),
    );
  }
}
