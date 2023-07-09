
import 'package:dr_nimai/apiService/networking.dart';

var loginUrl = 'https://examoneapi.azurewebsites.net/AuthManagement/Login';

var registerUrl = 'https://examoneapi.azurewebsites.net/AuthManagement/Register';

class LoginApiHandler {
  final Map<String, dynamic> body;

  LoginApiHandler(this.body);

  Future<dynamic> login() async {
    print(loginUrl);
    print(body);
    ServicePost urlHelper = ServicePost(loginUrl, body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }

  Future<dynamic> register() async {
    print(registerUrl);
    print(body);
    ServicePost urlHelper = ServicePost(registerUrl, body);
    var urlsData = await urlHelper.data();
    return urlsData;
  }
}
