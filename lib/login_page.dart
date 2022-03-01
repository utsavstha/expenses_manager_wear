import 'package:expense_manager_wear/app_cache.dart';
import 'package:expense_manager_wear/budget_page.dart';
import 'package:flutter/material.dart';

import 'http_requests.dart';
import 'login_model.dart';
import 'shape_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

void _login(BuildContext context, String email, String password) async {
  HttpRequest httpRequest = HttpRequest();
  final Map<String, String> data = {
    "email": email,
    "password": password,
  };
  try {
    var response = await httpRequest.post(
        "http://192.168.10.65:3000/api/v1/users/login", data);

    LoginModel loginModel = LoginModel.fromJson(response);
    if (loginModel.status == 'success') {
      AppCache.token = loginModel.token;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BudgetPage()),
      );
    }
    // print(loginModel.status);
    // return Success(true);
  } catch (e) {
    print(e);
    // return Failure('Could not login');
  }
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WatchShape(
            builder: (BuildContext context, WearShape shape, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  child: TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 30,
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your password',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity, // <-- match_parent
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xffff3378),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    onPressed: () {
                      _login(context, email.text, password.text);
                    },
                    child: Text(
                      "LOGIN",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
