class Token_jwt {
  int id;
  String token;

  Token_jwtMap(){
    var mapping = Map<String,dynamic>();
    mapping['id'] = id;
    mapping['token'] = token;

    return mapping;
  }
  // Token_jwt(String img) {
  //   this.image = img;
  // }
}