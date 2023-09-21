import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_tracking_automation/Services/Users_Services.dart';

class Users_Cubit extends Cubit<void>
{
  Users_Cubit() : super(0);

  var userRepositories = Users_Repositories();


  Future<void> signOut() async {
    userRepositories.signOut();
  }

  Future<void> usersSignUp(String _email, _password, _username, _name, _phone, _photo) async {
    userRepositories.usersSignUp(_email, _password, _username, _name, _phone, _photo);
  }

  Future<void> resetPassword(String _email) async {
    userRepositories.resetPassword(_email);
  }

  Future<Map<String, String>> getDataFromDatabase() async {
    return userRepositories.getDataFromDatabase();
  }

}