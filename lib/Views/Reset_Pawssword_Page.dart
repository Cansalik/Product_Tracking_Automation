import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Cubit/Users_Cubit.dart';

class Reset_Pawssword_Page extends StatefulWidget {
  const Reset_Pawssword_Page({Key? key}) : super(key: key);

  @override
  State<Reset_Pawssword_Page> createState() => _Reset_Pawssword_PageState();
}

class _Reset_Pawssword_PageState extends State<Reset_Pawssword_Page> {

  final formKey = GlobalKey<FormState>();
  late String eMail;

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
                      Text("Merhaba,\nŞifreni Sıfırlamak için Mail Adresini Gir",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                      SizedBox(height: 50,),
                      TextFormField(
                        validator: (value) {if(value!.isEmpty) {return "Bilgileri Kontrol Edin!";} else {}},
                        onSaved: (value) {eMail = value!;},
                        decoration: customInputDecoration("E-Mail"),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 50,),
                      ElevatedButton(
                        child: Text("Şifreyi Sıfırla",style: TextStyle(color: Colors.pinkAccent),),
                        onPressed: ()
                        {
                          if(formKey.currentState!.validate())
                          {
                            formKey.currentState!.save();
                            try
                            {
                              context.read<Users_Cubit>().resetPassword(eMail);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Color(0xff21254A),
                                  content: Text("Kullanıcı Sistemde Kayıtlı ise Şifre Sıfırlama İsteği Gönderilecek.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                                ),
                              );
                            }
                            catch (e)
                            {
                              print(e.toString());
                            }
                          }
                        },
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
