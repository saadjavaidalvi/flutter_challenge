import 'dart:convert';

import 'package:flutter_challenge/utils/custom_urls.dart';
import 'package:flutter_challenge/utils/http_wrapper.dart';
import 'package:http/http.dart' as http;

class DogBreeds {
  /// Get list of all of the breeds of dogs
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

  /// Get random image from a specific breed
  Future<String> getRandomBreedPicture(String breed) async {
    http.Response response = await CustomHttp().get(
      Uri.parse(
        CustomUrls.randomBreedimage(breed),
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

  /// Get random image from a specific breed
  Future<String> getRandomSubBreedPicture(String breed, String subBreed) async {
    http.Response response = await CustomHttp().get(
      Uri.parse(
        CustomUrls.randomSubBreedimage(breed, subBreed),
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

  /// Get list of all of the images by breed
  Future<List> getBreedAllImages(String breed) async {
    http.Response response = await CustomHttp().get(
      Uri.parse(
        CustomUrls.allbreedimages(breed),
      ),
    );

    if (response.statusCode == 200) {
      Map responseBody = jsonDecode(response.body);
      if (responseBody['message'] is List) {
        return responseBody['message'];
      }
      return [];
    } else {
      return [];
    }
  }

  /// Get list of all of the breeds of dogs
  Future<List> getsubBreedAllImages(String breed, String subBreed) async {
    http.Response response = await CustomHttp().get(
      Uri.parse(
        CustomUrls.allsubBreedimages(breed, subBreed),
      ),
    );

    if (response.statusCode == 200) {
      Map responseBody = jsonDecode(response.body);
      if (responseBody['message'] is List) {
        return responseBody['message'];
      }
      return [];
    } else {
      return [];
    }
  }
}
