import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dr_nimai/main.dart';


//keep header
class ServiceGet {
  final String url;

  ServiceGet(this.url);

  Future data() async {
    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type':'application/json',
          'Authorization': 'Bearer '+ MyApp.authTokenValue.toString(),
        }
    );
    print(response.body);
    String data = response.body;
    if (response.statusCode == 200) {
      return [response.statusCode, jsonDecode(data)];
    } else {
      return [response.statusCode];
    }
  }
}

class ServicePost {
  final String url;
  final body;

  ServicePost(this.url,this.body);

  Future data() async {
    final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          'Content-Type':'application/json'
        }
    );
    print(url);
    print(response.body);
    String data = response.body;
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('here');
      if(data!=''){
        return [response.statusCode, jsonDecode(data)];
      }else{
        return [response.statusCode];
      }

    } else {
      return [response.statusCode,jsonDecode(data)];
    }
  }
}

//keep header
class ServicePostWithHeader {
  final String url;
  final body;

  ServicePostWithHeader(this.url,this.body);

  Future data() async {
    final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          'Content-Type':'application/json',
          'Authorization': 'Bearer ' + MyApp.authTokenValue.toString(),
        }
    );
    print(url);
    print(response.body);
    String data = response.body;
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('here');
      if(data!=''){
        return [response.statusCode, jsonDecode(data)];
      }else{
        return [response.statusCode,jsonDecode(data)];
      }

    } else {
      return [response.statusCode,jsonDecode(data)];
    }
  }
}