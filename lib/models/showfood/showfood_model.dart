// To parse this JSON data, do
//
//     final showFoods = showFoodsFromJson(jsonString);

import 'dart:convert';

ShowFoods showFoodsFromJson(String str) => ShowFoods.fromJson(json.decode(str));

String showFoodsToJson(ShowFoods data) => json.encode(data.toJson());

class ShowFoods {
    ShowFoods({
        this.rid,
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.profileImage,
        this.recipeName,
        this.image,
        this.date,
        this.suitableFor,
        this.takeTime,
        this.foodCategory,
        this.description,
        this.price,
        this.ingredient,
        this.howto,
        this.score,
        this.count,
        this.comment,
    });

    int rid;
    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;
    String recipeName;
    String image;
    DateTime date;
    String suitableFor;
    String takeTime;
    String foodCategory;
    String description;
    double price;
    List<Ingredient> ingredient;
    List<Howto> howto;
    double score;
    int count;
    List<Comment> comment;

    factory ShowFoods.fromJson(Map<String, dynamic> json) => ShowFoods(
        rid: json["rid"],
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
        recipeName: json["recipe_name"],
        image: json["image"],
        date: DateTime.parse(json["date"]),
        suitableFor: json["suitable_for"],
        takeTime: json["take_time"],
        foodCategory: json["food_category"],
        description: json["description"],
        price: json["price"].toDouble(),
        ingredient: List<Ingredient>.from(json["ingredient"].map((x) => Ingredient.fromJson(x))),
        howto: List<Howto>.from(json["howto"].map((x) => Howto.fromJson(x))),
        score: json["score"].toDouble(),
        count: json["count"],
        comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "rid": rid,
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "profile_image": profileImage,
        "recipe_name": recipeName,
        "image": image,
        "date": date.toIso8601String(),
        "suitable_for": suitableFor,
        "take_time": takeTime,
        "food_category": foodCategory,
        "description": description,
        "price": price,
        "ingredient": List<dynamic>.from(ingredient.map((x) => x.toJson())),
        "howto": List<dynamic>.from(howto.map((x) => x.toJson())),
        "score": score,
        "count": count,
        "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
    };
}

class Comment {
    Comment({
        this.userId,
        this.nameSurname,
        this.aliasName,
        this.profileImage,
        this.cid,
        this.recipeId,
        this.commentDetail,
        this.datetime,
    });

    int userId;
    String nameSurname;
    String aliasName;
    String profileImage;
    int cid;
    int recipeId;
    String commentDetail;
    DateTime datetime;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        userId: json["user_ID"],
        nameSurname: json["name_surname"],
        aliasName: json["alias_name"],
        profileImage: json["profile_image"],
        cid: json["cid"],
        recipeId: json["recipe_ID"],
        commentDetail: json["commentDetail"],
        datetime: DateTime.parse(json["datetime"]),
    );

    Map<String, dynamic> toJson() => {
        "user_ID": userId,
        "name_surname": nameSurname,
        "alias_name": aliasName,
        "profile_image": profileImage,
        "cid": cid,
        "recipe_ID": recipeId,
        "commentDetail": commentDetail,
        "datetime": datetime.toIso8601String(),
    };
}

class Howto {
    Howto({
        this.howtoId,
        this.description,
        this.step,
        this.pathFile,
        this.typeFile,
    });

    int howtoId;
    String description;
    int step;
    String pathFile;
    String typeFile;

    factory Howto.fromJson(Map<String, dynamic> json) => Howto(
        howtoId: json["howto_ID"],
        description: json["description"],
        step: json["step"],
        pathFile: json["path_file"],
        typeFile: json["type_file"],
    );

    Map<String, dynamic> toJson() => {
        "howto_ID": howtoId,
        "description": description,
        "step": step,
        "path_file": pathFile,
        "type_file": typeFile,
    };
}

class Ingredient {
    Ingredient({
        this.ingredientsId,
        this.ingredientName,
        this.amount,
        this.step,
    });

    int ingredientsId;
    String ingredientName;
    String amount;
    int step;

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        ingredientsId: json["ingredients_ID"],
        ingredientName: json["ingredientName"],
        amount: json["amount"],
        step: json["step"],
    );

    Map<String, dynamic> toJson() => {
        "ingredients_ID": ingredientsId,
        "ingredientName": ingredientName,
        "amount": amount,
        "step": step,
    };
}
