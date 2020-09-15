import 'dart:convert';

import 'package:iblood/SignUp.dart';
import 'package:iblood/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loadingprogress = false;
  @override
  Widget build(BuildContext context) {
   Future<String> _login() async {
      var result;
      setState(() {
        loadingprogress = true;
      });
      try {
        var url = "https://unconcealed-carrier.000webhostapp.com/login.php";
        var data = {
          "email": emailController.text,
          "pass": passwordController.text,
        };
        var res = await http.post(url, body: data);
         result = jsonDecode(res.body);

      } catch (e) {
      }
      setState(() {
        loadingprogress = false;
      });
      if (result == 'true') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Temp()));
      } else {
      }

    }

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: loadingprogress,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'eBlood',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'email',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  textColor: Colors.blue,
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () async{
                        _login();
                      },
                    )),
                SizedBox(height: 10),
                Container(
                    child: m.Row(
                  children: <Widget>[
                    Text('Does not have account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )),
      ),
    );
  }
}
