class Products
{
  late String product_id;
  late String categori_name;
  late String product_name;
  late String product_price;
  late int product_barcode;
  late int product_piece;
  late String product_image_1;
  late String product_image_2;
  late String product_image_3;
  late String product_image_4;

  Products(
      this.product_id, this.categori_name, this.product_name, this.product_barcode, this.product_price, this.product_piece,
      this.product_image_1, this.product_image_2, this.product_image_3, this.product_image_4);


  factory Products.fromJson(String key, Map<dynamic, dynamic> json)
  {
    return Products(
        key,
        json["categori_name"] as String,
        json["product_name"] as String,
        json["product_barcode"] as int,
        json["product_price"] as String,
        json["product_piece"] as int,
        json["product_image_1"] as String,
        json["product_image_2"] as String,
        json["product_image_3"] as String,
        json["product_image_4"] as String
    );
  }
}