import 'dart:convert';

import 'package:http/http.dart' as http;

fetchdata(a , b , c ) async {
  try {

    http.Response response = await http.get(Uri.parse("http://192.168.8.102:5000/"+a.toString()+'/'+b.toString()+'/'+c.toString()));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return "Error: ${response.statusCode}";
    }
  } catch (e) {
    return "Error: $e";
  }
}