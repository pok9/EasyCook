import 'package:shared_preferences/shared_preferences.dart';

class Token_jwt {
  // int id;
  // String token;

  // Token_jwtMap(){
  //   var mapping = Map<String,dynamic>();
  //   mapping['id'] = id;
  //   mapping['token'] = token;

  //   return mapping;
  // }

  void storeToken(String token) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("token", token);
}

Future<String> getTokens() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("token") ?? null;
}
  
}