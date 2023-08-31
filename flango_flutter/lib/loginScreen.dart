import 'dart:convert';

import 'package:flango_chat/registerScreen.dart';
import 'package:flango_chat/toasts.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'apiService.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _submitForm(context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    WebViewController _con;

    FocusScope.of(context).unfocus();

    var response = await _apiService.loginRequest(username, password);
    if (response.statusCode == 500) {
      showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return WebView(
            initialUrl: Uri.dataFromString(
              response!.body,
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ).toString(),
            debuggingEnabled: true,
          );
        },
      );
    } else {
      if (response['status']) {
        greenToast(response.message);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(),
          ),
        );
      } else {
        redToast(response.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                  (route) => false),
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
