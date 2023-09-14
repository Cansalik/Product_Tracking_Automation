import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Cubit/Users_Cubit.dart';
import 'package:product_tracking_automation/Views/Homepage.dart';
import 'package:product_tracking_automation/Views/Homepage_BottomNavigatorBar.dart';
import 'package:product_tracking_automation/Views/My_Account_Page.dart';
import 'package:product_tracking_automation/Views/Reset_Pawssword_Page.dart';
import 'package:product_tracking_automation/Views/Sign_Up_Page.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {

  late String _email, _password;
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async
      {
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
                        Text("Merhaba, \n Hoşgeldiniz.",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                        TextFormField(
                          validator: (value) {if(value!.isEmpty) {return "Bilgileri Kontrol Edin!";} else {}},
                          onSaved: (value) {_email = value!;},
                          decoration: customInputDecoration("E Mail"),
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
                        SizedBox(height: 20,),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if(formKey.currentState!.validate())
                              {
                                formKey.currentState!.save();
                                try
                                {
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage_BottomNavigationBar()));
                                }
                                on FirebaseAuthException catch (e)
                                {
                                  if(e.code == "user-not-found")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Color(0xff21254A),
                                        content: Text("Email Yanlış",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                      ),
                                    );
                                  }
                                  else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Color(0xff21254A),
                                        content: Text("Hata oluştu! Lütfen Şifreyi ve İnternet Bağlantısını Kontrol Edin",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                      ),
                                    );
                                  }
                                }
                              }
                              else
                              {
                              }
                            },
                            child: Text("Giriş Yap",style: TextStyle(color: Colors.pinkAccent),),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: TextButton(
                            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> Reset_Pawssword_Page()));},
                            child: Text("Şifremi Unuttum",style: TextStyle(color: Colors.pinkAccent),),),
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: TextButton(
                            onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => Sign_Up_Page())),},
                            child: Text("Hesap Oluşur",style: TextStyle(color: Colors.pinkAccent),),),
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
