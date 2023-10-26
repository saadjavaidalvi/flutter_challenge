import 'dart:convert';

// import 'package:flutter_challenge/utils/connectivity.dart';
import 'package:flutter_challenge/utils/http_wrapper.dart';
import 'package:http/http.dart' as http;

class DogBreeds {
  Future<Map> getAllBreeds() async {
    http.Response response = await CustomHttp().get(
      Uri.parse(
        'https://dog.ceo/api/breeds/list/all',
      ),
    );

    if (response.statusCode == 200) {
      Map responseBody = jsonDecode(response.body);
      if (responseBody['message'] is Map) {
        return responseBody['message'];
      }
      return {};
    } else {
      return {};
    }
  }

  Future<String> getRandomBreedPicture(String breed) async {
    http.Response response = await CustomHttp().get(
      Uri.parse(
        'https://dog.ceo/api/breed/${breed.toLowerCase()}/images/random',
      ),
    );

    if (response.statusCode == 200) {
      Map responseBody = jsonDecode(response.body);
      if (responseBody['message'] is String) {
        return responseBody['message'];
      }
      return '';
    } else {
      return '';
    }
  }
}
