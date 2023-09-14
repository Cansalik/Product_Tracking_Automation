class Categories
{
  late String categori_id;
  late String categori_name;
  late String categori_image;


  Categories(this.categori_id, this.categori_name, this.categori_image);

  factory Categories.fromJson(String key, Map<dynamic, dynamic> json)
  {
    return Categories(key, json["categori_name"] as String, json["categori_image"] as String);
  }
}