import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_tracking_automation/Cubit/Users_Cubit.dart';

class My_Account_Page extends StatefulWidget {
  const My_Account_Page({Key? key}) : super(key: key);

  @override
  State<My_Account_Page> createState() => _My_Account_PageState();
}


class _My_Account_PageState extends State<My_Account_Page> {

  final formKey = GlobalKey<FormState>();
  String? email = "", name = "", username = "", phone = "", photo = "";

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_images').child(DateTime.now().millisecondsSinceEpoch.toString()); // Depolama yolu tanımlayın
      await storageRef.putFile(imageFile); // Resmi Firebase Storage'a yükleyin
      final imageUrl = await storageRef.getDownloadURL(); // Resmin URL'sini alın
      return imageUrl;
    }
    catch (e)
    {
      return null;
    }
  }

  @override
  void initState() {
    context.read<Users_Cubit>().getDataFromDatabase().then((userData){
      setState(() {
        email = userData["email"];
        name = userData["name"];
        username = userData["username"];
        phone = userData["phone"];
        photo = userData["photo"];
      });
    });
    super.initState();
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height * 0.25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/topImage.png",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hesabım",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                      SizedBox(height: 25,),
                      Center(child: SizedBox(width:100, height:100,child: Image.network("$photo"))),
                      Center(
                        child: TextButton(
                            child: Text("Profil Fotoğrafını Değiştir",style: TextStyle(color: Colors.pinkAccent),),
                            onPressed: () async
                            {
                              final imagePicker = ImagePicker();
                              final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery); // Kullanıcıya galeriden bir resim seçme seçeneği sunulur
                              if (pickedFile != null) {
                                final imageUrl = await uploadImageToFirebaseStorage(File(pickedFile.path)); // Seçilen resmi Firebase Storage'a yükleyin
                                if (imageUrl != null) {
                                  // Resmi Firebase Storage'dan başarıyla yükledikten sonra, imageUrl'i kullanarak profil resmini güncelleyebilirsiniz.
                                  setState(() {
                                    photo = imageUrl;
                                  });
                                }
                              }
                              try {await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"photo": photo,},);} catch (e) {print(e.toString());}
                            }
                        ),
                      ),
                      SizedBox(height: 25,),
                      Text("Ad Soyad: $name",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                      SizedBox(height: 20,),
                      Text("E-Posta: $email",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                      SizedBox(height: 20,),
                      Text("Kullanıcı Adı: $username",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                      SizedBox(height: 20,),
                      Text("Telefon Numarası: $phone",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
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
