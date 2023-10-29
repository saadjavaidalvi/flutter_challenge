class CustomUrls {
  static String baseUrl = 'https://dog.ceo/api/breed';

  static String allBreedList = '${baseUrl}s/list/all';

  static String randomBreedimage(String breed) {
    return '$baseUrl/${breed.toLowerCase()}/images/random';
  }

  static String randomSubBreedimage(String breed, String subBreed) {
    return '$baseUrl/${breed.toLowerCase()}/${subBreed.toLowerCase()}/images/random';
  }

  static String allbreedimages(String breed) {
    return '$baseUrl/${breed.toLowerCase()}/images';
  }

  static String allsubBreedimages(String breed, String subBreed) {
    return '$baseUrl/${breed.toLowerCase()}/${subBreed.toLowerCase()}/images';
  }
}
