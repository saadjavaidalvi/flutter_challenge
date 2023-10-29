import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/middlewares/dog_breeds.dart';
import 'package:flutter_challenge/pages/dogs_gallery_page.dart';
import 'package:flutter_challenge/utils/assets_strings.dart';
import 'package:flutter_challenge/utils/custom_strings.dart';
import 'package:flutter_challenge/utils/helper_methods.dart';
import 'package:flutter_challenge/widgets/capsule_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
    this.breadsData, {
    super.key,
  });
  final Map breadsData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedValue = '';
  String selectedSubBreed = '';
  late final String subBreedSelectOptionString;
  List breadsList = [];
  bool randomButtonLoading = false;
  bool showAllButtonLoading = false;

  @override
  void initState() {
    super.initState();
    subBreedSelectOptionString = CustomStrigns().selectSubbreedOptionText;

    breadsList = widget.breadsData.keys.toList();
    if (breadsList.isNotEmpty) {
      selectedValue = breadsList.first;
    }
    selectedSubBreed = subBreedSelectOptionString;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundWidget(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              CustomStrigns().homeScreenAppbarText.toUpperCase(),
            ),
          ),
          body: bodyWidget(),
        ),
      ],
    );
  }

  Widget backgroundWidget() {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            AssetString().backgroundImage,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white.withOpacity(.95),
        ),
      ],
    );
  }

  Widget bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16,
          ),
          child: Text(
            CustomStrigns().homescreenTitleText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        widget.breadsData.isEmpty
            ? Column(
                children: [
                  Text(
                    CustomStrigns().noBreedDataString,
                  )
                ],
              )
            : Column(
                children: [
                  selectBreed(),
                  Container(
                    height: 24,
                  ),
                  selectSubBreed(),
                ],
              ),
        widget.breadsData.isEmpty
            ? Container()
            : Column(
                children: [
                  randomButton(),
                  showAllButton(),
                  Container(
                    height: 40,
                  )
                ],
              ),
      ],
    );
  }

  Widget selectBreed() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            CustomStrigns().selectBreedText,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton(
                borderRadius: BorderRadius.circular(12),
                underline: const SizedBox(),
                alignment: Alignment.center,
                value: HelperMethods().capitalize(selectedValue),
                items: List.generate(
                  breadsList.length,
                  (index) => dropDownIteam(
                    HelperMethods().capitalize(
                      breadsList[index],
                    ),
                    text: (widget.breadsData[breadsList[index]] as List).isEmpty
                        ? HelperMethods().capitalize(
                            breadsList[index],
                          )
                        : "${HelperMethods().capitalize(
                            breadsList[index],
                          )} (${(widget.breadsData[breadsList[index]] as List).length.toString()})",
                  ),
                ),
                onChanged: (value) {
                  selectedValue = value ?? '';
                  selectedSubBreed = subBreedSelectOptionString;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        (widget.breadsData[selectedValue.toLowerCase()] as List).isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 24,
                ),
                child: Text(
                  CustomStrigns().noSubbreedText,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Container(),
      ],
    );
  }

  Widget selectSubBreed() {
    List<String> subBreedsListWithSelectOption = handleSubBreedSelectLogic(
        (widget.breadsData[selectedValue.toLowerCase()] as List));

    return !hasSubbreeds()
        ? Container()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  CustomStrigns().selectSubbreedText,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton(
                      borderRadius: BorderRadius.circular(12),
                      underline: const SizedBox(),
                      alignment: Alignment.center,
                      value: selectedSubBreed,
                      items: List.generate(
                        subBreedsListWithSelectOption.length,
                        (index) => dropDownIteam(
                          HelperMethods().capitalize(
                            subBreedsListWithSelectOption[index],
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        selectedSubBreed = value ?? '';
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  DropdownMenuItem dropDownIteam(
    String value, {
    String? text,
  }) {
    return DropdownMenuItem(
      value: value,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Text(
          text ?? value,
        ),
      ),
    );
  }

  Widget randomButton() {
    return AbsorbPointer(
      absorbing: randomButtonLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          children: [
            Expanded(
              child: MyCapsuleButton(
                isLoading: randomButtonLoading,
                text: CustomStrigns().getRandomImageButtonText.toUpperCase(),
                onTap: () async {
                  setState(() {
                    randomButtonLoading = true;
                  });

                  String imageUrl = '';
                  if (isSubBreedSelected()) {
                    imageUrl = await DogBreeds().getRandomSubBreedPicture(
                        selectedValue, selectedSubBreed);
                  } else {
                    imageUrl =
                        await DogBreeds().getRandomBreedPicture(selectedValue);
                  }
                  setState(() {
                    randomButtonLoading = false;
                  });
                  if (imageUrl.isEmpty) {
                    return;
                  }
                  randomDogPictureDialouge(imageUrl);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A function that pop ups the dialoug to show a random picture of dog
  void randomDogPictureDialouge(String imageUrl) {
    // ignore: use_build_context_synchronously
    showDialog(
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${HelperMethods().capitalize(selectedValue)} ${isSubBreedSelected() ? "($selectedSubBreed)" : ''}',
                textAlign: TextAlign.center,
              ),
              Container(
                height: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  height: 200,
                  imageUrl: imageUrl,
                  fadeOutDuration: const Duration(seconds: 0),
                  fadeInDuration: const Duration(seconds: 0),
                  placeholder: (context, url) => Image.asset(
                    AssetString().runningDogGif,
                    height: 50,
                    width: 50,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
            ],
          ),
        ),
      ),
      context: context,
    );
  }

  /// This function check if a sub-breed is selected or not
  bool isSubBreedSelected() {
    if (selectedSubBreed == subBreedSelectOptionString) {
      return false;
    }

    return true;
  }

  /// A button that will lead to the gallery containing images for dogs
  Widget showAllButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: MyCapsuleButton(
              text: CustomStrigns().showAllImageButtonText.toUpperCase(),
              onTap: () {
                String? subbreed =
                    !isSubBreedSelected() ? null : selectedSubBreed;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DogsGalleryPage(
                      breed: selectedValue,
                      subbreed: subbreed,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// This is to add an extra String item in the DropDown for sub breed
  /// that would be the default value
  List<String> handleSubBreedSelectLogic(List breedsData) {
    List<String> subBreedsList = [];
    for (var i = 0; i < breedsData.length; i++) {
      subBreedsList.add(breedsData[i]);
    }
    if (subBreedsList.isNotEmpty) {
      if (subBreedsList[0] != subBreedSelectOptionString) {
        subBreedsList.insert(0, subBreedSelectOptionString);
      }
    }

    return subBreedsList;
  }

  bool hasSubbreeds() {
    return (widget.breadsData[selectedValue.toLowerCase()] as List).isNotEmpty;
  }
}
