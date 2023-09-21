class Users
{
  late String user_id;
  late String email;
  late String phone;
  late String name;
  late String photo;
  late String username;


  Users(this.user_id, this.email, this.phone, this.name, this.photo, this.username);

  factory Users.fromJson(String key, Map<dynamic, dynamic> json)
  {
    return Users(
      key,
      json["email"] as String,
      json["phone"] as String,
      json["name"] as String,
      json["photo"] as String,
      json["username"] as String,
    );
  }
}