import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/middlewares/dog_breeds.dart';
import 'package:flutter_challenge/pages/dogs_gallery_page.dart';
import 'package:flutter_challenge/utils/assets_strings.dart';
import 'package:flutter_challenge/utils/helper_methods.dart';
import 'package:flutter_challenge/widgets/capsule_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.breadsData, {super.key});
  final Map breadsData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedValue = 'data 0';
  String selectedSubBreed = 'Chosse Sub Breed';
  String subBreedSelectOptionString = 'Select sub-breed';
  List<String> breadsList = [];
  bool randomButtonLoading = false;
  bool showAllButtonLoading = false;

  @override
  void initState() {
    super.initState();

    breadsList = widget.breadsData.keys.toList() as List<String>;
    selectedValue = breadsList.first;
    selectedSubBreed = subBreedSelectOptionString;
  }

  @override
  Widget build(BuildContext context) {
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
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'We Love Dogs',
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16,
                ),
                child: Text(
                  'Select the below options for a randon or a list of images by breed and sub-breed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: [
                  selectBreed(),
                  Container(
                    height: 24,
                  ),
                  selectSubBreed(),
                ],
              ),
              Column(
                children: [
                  randomButton(),
                  showAllButton(),
                  Container(
                    height: 40,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget selectBreed() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Select a breed of dog from below',
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
            ? const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 24,
                ),
                child: Text(
                  '*This breed has no sub-breed',
                  style: TextStyle(
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

  Widget selectSubBreed() {
    List<String> subBreedsListWithSelectOption = handleSubBreedSelectLogic(
        (widget.breadsData[selectedValue.toLowerCase()] as List));
    return (widget.breadsData[selectedValue.toLowerCase()] as List).isEmpty
        ? Container()
        : Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Select a sub breed of dog (Optional)',
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
                text: 'Get a Random Image'.toUpperCase(),
                onTap: () async {
                  setState(() {
                    randomButtonLoading = true;
                  });

                  String respone = '';
                  if (isSubBreedSelected()) {
                    respone = await DogBreeds().getRandomSubBreedPicture(
                        selectedValue, selectedSubBreed);
                  } else {
                    respone =
                        await DogBreeds().getRandomBreedPicture(selectedValue);
                  }
                  setState(() {
                    randomButtonLoading = false;
                  });
                  if (respone.isEmpty) {
                    return;
                  }
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
                                imageUrl: respone,
                                fadeOutDuration: Duration(seconds: 0),
                                fadeInDuration: Duration(seconds: 0),
                                placeholder: (context, url) => Image.asset(
                                  AssetString().runningDogGif,
                                  height: 50,
                                  width: 50,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    context: context,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isSubBreedSelected() {
    if (selectedSubBreed == subBreedSelectOptionString) {
      return false;
    }

    return true;
  }

  Widget showAllButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: MyCapsuleButton(
              text: 'Show All Images'.toUpperCase(),
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
}
