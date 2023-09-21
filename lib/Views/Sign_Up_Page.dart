import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_tracking_automation/Cubit/Users_Cubit.dart';
import 'package:product_tracking_automation/Views/Login_Page.dart';

class Sign_Up_Page extends StatefulWidget {
  const Sign_Up_Page({Key? key}) : super(key: key);

  @override
  State<Sign_Up_Page> createState() => _Sign_Up_PageState();
}

class _Sign_Up_PageState extends State<Sign_Up_Page> {

  late String _email, _password, _username, _name, _phone, _photo;
  final formKey = GlobalKey<FormState>();

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_images').child(DateTime.now().millisecondsSinceEpoch.toString()); // Depolama yolu tanımlayın
      await storageRef.putFile(imageFile); // Resmi Firebase Storage'a yükleyin
      final imageUrl = await storageRef.getDownloadURL(); // Resmin URL'sini alın
      return imageUrl;
    } catch (e) {
      print('Resim yükleme hatası: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        context.read<Users_Cubit>().signOut();
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
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
                        Center(child: SizedBox(width:100, height:100,child: Image.asset("assets/images/User_Profile.png"),),),
                        Center(
                          child: TextButton(
                              child: Text("Profil Fotoğrafı Seç",style: TextStyle(color: Colors.pinkAccent),),
                              onPressed: () async
                              {
                                final imagePicker = ImagePicker();
                                final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  final imageUrl = await uploadImageToFirebaseStorage(File(pickedFile.path));
                                  if (imageUrl != null) {
                                    setState(() {
                                      _photo = imageUrl;// Resmin URL'sini _photo değişkenine ata
                                    });
                                  }
                                }
                              }
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          validator: (value) {if(value!.isEmpty) {return "Bilgileri Kontrol Edin!";} else {}},
                          onSaved: (value) {_email = value!;},
                          decoration: customInputDecoration("E Mail"),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          validator: (value) {if(value!.isEmpty) {return "Bilgileri Kontrol Edin!";} else {}},
                          onSaved: (value) {_name = value!;},
                          decoration: customInputDecoration("Ad Soyad"),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          validator: (value) {if(value!.isEmpty) {return "Bilgileri Kontrol Edin!";} else {}},
                          onSaved: (value) {_username = value!;},
                          decoration: customInputDecoration("Kullanıcı Adı"),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value)
                          {if(value!.isEmpty) {return "Bilgileri Kontrol Edin!";} else {}},
                          onSaved: (value) {_phone = value!;},
                          decoration: customInputDecoration("Telefon Numarası"),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          validator: (value) {if(value!.isEmpty) {return "Bilgileri Kontrol Edin!";} else {}},
                          onSaved: (value) {_password = value!;},
                          obscureText: true,
                          decoration: customInputDecoration("Şifre"),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              if(formKey.currentState!.validate())
                              {
                                formKey.currentState!.save();
                                try
                                {
                                  context.read<Users_Cubit>().usersSignUp(_email, _password, _username, _name, _phone, _photo);
                                  formKey.currentState!.reset();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Color(0xff21254A),
                                      content: Text("Kullanıcı Kaydedildi",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                    ),
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login_Page()));
                                }
                                on FirebaseAuthException catch (e)
                                {
                                  if(e.code == "invalid-email")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Color(0xff21254A),
                                        content: Text("E-Posta Hatalı",
                                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                catch(e)
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Color(0xff21254A),
                                      content: Text("Profil Fotoğrafı Seçmedin",
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }
                              }
                              else
                              {

                              }
                            },
                            child: Text("Hesap Oluştur",style: TextStyle(color: Colors.pinkAccent),),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login_Page()));
                            },
                            child: Text("Giriş Sayfasına Dön",style: TextStyle(color: Colors.pinkAccent),),
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
      ),
    );
  }
}

InputDecoration customInputDecoration(String hintText)
{
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
