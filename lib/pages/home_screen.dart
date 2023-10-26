import 'package:flutter/material.dart';
import 'package:flutter_challenge/middlewares/get_breeds.dart';
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
  List<String> breadsList = [];

  @override
  void initState() {
    super.initState();

    breadsList = widget.breadsData.keys.toList() as List<String>;
    selectedValue = breadsList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'We Love Dogs',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Please select the below options for a randon or a list of images by  breed or sub-breed',
              style: TextStyle(
                fontSize: 16,
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
                /* icon: const Icon(
                  Icons.pets,
                ), */
                alignment: Alignment.center,
                value: HelperMethods().capitalize(selectedValue),
                items: List.generate(
                  breadsList.length,
                  (index) => DropdownMenuItem(
                    value: HelperMethods().capitalize(
                      breadsList[index],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      HelperMethods().capitalize(
                        breadsList[index],
                      ),
                    ),
                  ),
                ),
                onChanged: (value) {
                  selectedValue = value ?? '';
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget selectSubBreed() {
    return (widget.breadsData[selectedValue.toLowerCase()] as List).isEmpty
        ? const Text(
            '*This breed has no sub-breed. Selected some other breed to see its sub-breed',
            style: TextStyle(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          )
        : Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Please select a sub breed of dog (Optional)',
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
                        (index) => DropdownMenuItem(
                          value: HelperMethods().capitalize(
                            breadsList[index],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            HelperMethods().capitalize(
                              breadsList[index],
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        selectedValue = value ?? '';
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  Widget randomButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: MyCapsuleButton(
              text: 'Random Image',
              onTap: () async {
                String respone =
                    await DogBreeds().getRandomBreedPicture(selectedValue);
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
                            'Breed: $selectedValue',
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            height: 12,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              respone,
                              height: 200,
                              // width: 200,
                              fit: BoxFit.fitHeight,
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
    );
  }

  Widget showAllButton() {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: MyCapsuleButton(
              text: 'Show All Image',
            ),
          ),
        ],
      ),
    );
  }
}
