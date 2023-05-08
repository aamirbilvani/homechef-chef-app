import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Order {
  String _id = "";

	String ordernum;
	String status;
	String orderdate;

	int foodieTotal;
	int totalprice;
	int deliverycharges;
  double platformfee;
  double platformfee_gross;
	double platformfee_percent;
	String pickupaddress;
	String ordernotes;
	String ordertype;
	String pickuptimestamp;
	String deliverytimestamp;
  String rider_pickup_arrived_time;
	String deliverydate;
	String deliverytime;
	String sub_order_id;
	Confirmations confirmations;
  String sub_title;
  bool chef_ordernotes_viewed;
  String sub_chef_pickup_time;

  List<OrderDish> dishes = new List<OrderDish>();

  String getFormattedPickup() {
    DateTime dt = DateTime.parse(pickuptimestamp).toLocal();
    var dateFormat = new DateFormat('E, d MMM | h:mm a');
    return dateFormat.format(dt);
  }


  Map<String, dynamic> toJson() => {
        '_id': _id,
        'ordernum': ordernum,
        'status': status,
        'orderdate': orderdate,
        'foodieTotal': foodieTotal,
        'totalprice': totalprice,
        'deliverycharges': deliverycharges,
        'platformfee': platformfee.toDouble(),
        'platformfee_gross': platformfee_gross.toDouble(),
        'platformfee_percent': platformfee_percent,
        'pickupaddress': pickupaddress,
        'ordernotes': ordernotes,
        'ordertype': ordertype,
        'pickuptimestamp': pickuptimestamp,
        'deliverytimestamp': deliverytimestamp,
        'rider_pickup_arrived_time': rider_pickup_arrived_time,
        'deliverydate': deliverydate,
        'deliverytime': deliverytime,
        'sub_order_id': sub_order_id,
        'confirmations': confirmations,
        'dishes': dishes,
        'sub_title': sub_title,
        'chef_ordernotes_viewed': chef_ordernotes_viewed,
        'sub_chef_pickup_time': sub_chef_pickup_time
    };

    Order.fromJson(Map<String, dynamic> json)
        :   _id = json['_id'],
            ordernum = json['ordernum'],
            status = json['status'],
            orderdate = json['orderdate'],

            foodieTotal = json['foodieTotal'],
            totalprice = json['totalprice'],
            deliverycharges = json['deliverycharges'].round(),
            platformfee = json['platformfee'].toDouble(),
            platformfee_gross = json['platformfee_gross'].toDouble(),
            platformfee_percent = (json['platformfee_percent']).toDouble(),
            pickupaddress = json['pickupaddress'].toString(),
            ordernotes = json['ordernotes'],
            ordertype = json['ordertype'].toString(),
            pickuptimestamp = json['pickuptimestamp'],

            deliverytimestamp = json['deliverytimestamp'],
            rider_pickup_arrived_time = json['rider_pickup_arrived_time'],
            deliverydate = json['deliverydate'],
            deliverytime = json['deliverytime'],
            sub_order_id = json['sub_order_id'],
            sub_title = json['sub_title'],
            confirmations = Confirmations.fromJson(json['confirmations']),
            dishes = json['dishes'].map<OrderDish>((i)=>OrderDish.fromJson(i)).toList(),
            chef_ordernotes_viewed = json['chef_ordernotes_viewed'] ? true : false,
            sub_chef_pickup_time = (json['sub_chef_pickup_time'] != null) ? json['sub_chef_pickup_time'] : "";

    bool isChefConfirmed() {
      return confirmations.chef != null && confirmations.chef != "" && confirmations.chef != "None";
    }

    bool hasOrderNotes() {
      return ordernotes != null && ordernotes != "" && ordernotes != "null";
    }

    String getId() {
      return _id;
    }
}


class OrderDish {
		String dish;
		String name;
		String type;
		String description;
		String servingtype;
		int servingquantity;
		int serves;
		String cuisine;
		List<String> features;
		String photo;
		int price;
		int costprice;
		int discountprice;
		int discount;
		String pickupdatetime;
		String deliverydatetime;
		int quantity;
    String sub_title;


      Map<String, dynamic> toJson() => {
        'dish': dish,
        'name': name,
        'type': type,
        'description': description,
        'servingtype': servingtype,
        'servingquantity': servingquantity,
        'serves': serves,
        'cuisine': cuisine,
        'features': features,
        'photo': photo,
        'price': price,
        'costprice': costprice,
        'discountprice': discountprice,
        'discount': discount,
        'pickupdatetime': pickupdatetime,
        'deliverydatetime': deliverydatetime,
        'quantity': quantity,
        'sub_title': sub_title,
    };

    OrderDish.fromJson(Map<String, dynamic> json)
        :   dish = json['dish'],
            name = json['name'],
            type = json['type'],
            description = json['description'],
            servingtype = json['servingtype'],
            servingquantity = json['servingquantity'],
            serves = json['serves'],
            cuisine = json['cuisine'].toString(),
            features = List.from(json['features']),
            photo = json['photo'],
            price = json['price'],
            costprice = json['costprice'],
            discountprice = json['discountprice'],
            discount = json['discount'],
            pickupdatetime = json['pickupdatetime'],
            deliverydatetime = json['deliverydatetime'],
            quantity = json['quantity'],
            sub_title = json['sub_title'];

    Image getDishTypeImage() {
      if(type == null || type == "" || type == "Other")
        return Image.asset("images/servingtype.png");

      if(type == "Condiments")
        return Image.asset("images/dishtypes/condiments.png");
      if(type == "Dessert")
        return Image.asset("images/dishtypes/desserts.png");
      if(type == "Drinks")
        return Image.asset("images/dishtypes/drinks.png");
      if(type == "Main Dish")
        return Image.asset("images/dishtypes/Main-dish.png");
      if(type == "Side Dish")
        return Image.asset("images/dishtypes/side-dish.png");
      if(type == "Snack")
        return Image.asset("images/dishtypes/snacks.png");

      return Image.asset("images/servingtype.png");
    }

    String getFirstDietaryNeed() {
      if(features == null || features.length == 0)
        return null;
      
      return features[0];
    }

    Image getDietaryNeedsImage() {
      if(features == null || features.length == 0)
        return Image.asset("images/servingtype.png");

      if(features[0] == "All Natural")
        return Image.asset("images/dietaryneeds/all-natural.png");
      if(features[0] == "Gluten Free")
        return Image.asset("images/dietaryneeds/gluten-free.png");
      if(features[0] == "Keto")
        return Image.asset("images/dietaryneeds/keto.png");
      if(features[0] == "Low Calorie")
        return Image.asset("images/dietaryneeds/low-cal.png");
      if(features[0] == "Low Fat")
        return Image.asset("images/dietaryneeds/low-fat.png");
      if(features[0] == "Organic")
        return Image.asset("images/dietaryneeds/organic.png");
      if(features[0] == "Sugar Free")
        return Image.asset("images/dietaryneeds/sugar-free.png");
      if(features[0] == "Vegetarian")
        return Image.asset("images/dietaryneeds/vegetables.png");
      if(features[0] == "Vegan")
        return Image.asset("images/dietaryneeds/vegetables.png");

      return Image.asset("images/servingtype.png");
    }
}

class Confirmations {
    String chef;

      Map<String, dynamic> toJson() => {
        'chef': chef
    };

    Confirmations.fromJson(Map<String, dynamic> json)
        :   chef = json['chef'];
}
