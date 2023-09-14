import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_tracking_automation/Cubit/Categories_Cubit.dart';

class Add_NewProduct_Page extends StatefulWidget {
  const Add_NewProduct_Page({Key? key}) : super(key: key);

  @override
  State<Add_NewProduct_Page> createState() => _Add_NewProduct_PageState();
}

class _Add_NewProduct_PageState extends State<Add_NewProduct_Page> with TickerProviderStateMixin {

  var _firebaseProduct = FirebaseDatabase.instance.ref().child("Products");
  late String categoryName;
  final formKey = GlobalKey<FormState>();


  TextEditingController tfProductName = TextEditingController();
  TextEditingController tfproductPrice = TextEditingController();
  TextEditingController tfbarcode = TextEditingController();

  List<File?> imageFiles = List.generate(4, (index) => null);
  String selectedCategory = 'Lütfen Ürünün Kategorisini Seçin';



  Future<void> uploadProduct() async {
    try {
      // Firebase Storage'a resimleri yükleme
      List<String?> imageUrls = [];
      for (int i = 0; i < imageFiles.length; i++) {
        File? imageFile = imageFiles[i];
        if (imageFile != null) {
          String? imageUrl = await uploadImageToFirebaseStorage(imageFile);
          if (imageUrl != null) {
            imageUrls.add(imageUrl);
          }
        }
      }
      var values = Map<String, dynamic>();
      values["product_id"] = "";
      values["product_name"] = tfProductName.text;
      values["product_price"] = tfproductPrice.text;
      values["product_barcode"] = int.parse(tfbarcode.text);
      values["product_piece"] = 0;
      values["categori_name"] = categoryName;
      values["product_image_1"] = imageUrls[0];
      values["product_image_2"] = imageUrls[1];
      values["product_image_3"] = imageUrls[2];
      values["product_image_4"] = imageUrls[3];
      _firebaseProduct.push().set(values);
      Navigator.pop(
        context,
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1000),
            backgroundColor: Color(0xff21254A),
            content: Text(
              "Kaydedildi",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xff21254A),
          content: Text(
            "Ürün Kaydedilirken Bir Hata Oluştu, Lütfen Alanları Kontrol Edin",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Future<void> pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        imageFiles[index - 1] = imageFile;
      });
    }
  }

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('product_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString()); // Depolama yeri
      await storageRef.putFile(imageFile); // Resmi Firebase Storage'a yükle
      final imageUrl = await storageRef.getDownloadURL(); // Resmin URL'sini al
      return imageUrl;
    } catch (e) {
      return null;
    }
  }



  @override
  void initState() {
    context.read<Categories_Cubit>().categoryLoad();
    super.initState();
  }


  late int selectedProductIndex = 0;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap: () async {pickImage(1);}, child: CustomCard(imagePath: imageFiles[0],),),
                    GestureDetector(onTap: () async {pickImage(2);}, child: CustomCard(imagePath: imageFiles[1],),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap: () async {pickImage(3);}, child: CustomCard(imagePath: imageFiles[2],),),
                    GestureDetector(onTap: () async {pickImage(4);}, child: CustomCard(imagePath: imageFiles[3],),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0,right: 25.0),
                  child: Column(
                    children: [
                      CupertinoButton(
                          child: Text(
                            selectedCategory,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
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
                                children: context.read<Categories_Cubit>().categoryList.map<Widget>((String value) {
                                  return GestureDetector(
                                      onTap: ()
                                      {
                                        setState(() {
                                          categoryName = value;
                                          selectedCategory = categoryName;
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Center(child: Text(value, style: TextStyle(color: Colors.black),)));
                                }).toList(),
                              ),
                            ),
                          )
                      ),
                      TextField(
                        maxLength: 37,
                        buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) {return SizedBox.shrink();},
                        controller: tfProductName,
                        style: TextStyle(color: Colors.white,),
                        decoration: customInputDecoration("Ürün Adı"),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 37,
                        buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) {return SizedBox.shrink();},
                        controller: tfbarcode,
                        style: TextStyle(color: Colors.white,),
                        decoration: customInputDecoration("Barkod"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white,),
                          controller: tfproductPrice,
                          decoration: customInputDecoration("Ürün Fiyatı"),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed: () async {
                          uploadProduct();
                        },
                        child: Text("Ürünü Kaydet",
                          style: TextStyle(color: Colors.pinkAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class CustomCard extends StatelessWidget {
  final File? imagePath; // File tipinde resim alır

  CustomCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Card(
        elevation: 4.0,
        child: Container(
          width: 150.0,
          height: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (imagePath != null)
                Image.file(
                  imagePath!,
                  width: 300.0,
                  height: 195.0,
                ),
              if (imagePath == null)
                Text(
                  "Resim Ekleyin",
                  style: TextStyle(color: Colors.grey),
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


