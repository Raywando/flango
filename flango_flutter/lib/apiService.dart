import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const urlPrefix = 'http://192.168.71.128:7000/api';

class ApiService {
  Future loginRequest(String username, String password) async {
    final url = Uri.parse('$urlPrefix/login');
    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "username": username,
      "password": password,
    });

    final response = await http.post(url, headers: headers, body: json);
    print('$url Status code: ${response.statusCode}');
    if (response.statusCode == 200) print('Body: ${response.body}');

    return response;

    var data = jsonDecode(response.body);

    return data;
  }

  Future registerRequest(String username, String password, String email) async {
    final url = Uri.parse('$urlPrefix/register');
    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "username": username,
      "password": password,
      "email": email,
    });
    final response = await http.post(url, headers: headers, body: json);
    print('$url Status code: ${response.statusCode}');
    print('Body: ${response.body}');

    return response;

    var data = jsonDecode(response.body);

    return data;
  }
}