import 'package:flutter/material.dart';
import 'package:flutter_challenge/middlewares/dog_breeds.dart';

class DogsGalleryPage extends StatefulWidget {
  const DogsGalleryPage({
    super.key,
    required this.breed,
    this.subbreed,
  });
  final String breed;
  final String? subbreed;

  @override
  State<DogsGalleryPage> createState() => _DogsGalleryPageState();
}

class _DogsGalleryPageState extends State<DogsGalleryPage> {
  List imagesList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    List rerponseList = [];
    if (widget.subbreed != null && widget.subbreed!.isNotEmpty) {
      rerponseList = await DogBreeds()
          .getsubBreedAllImages(widget.breed, widget.subbreed!);
    } else {
      rerponseList = await DogBreeds().getBreedAllImages(widget.breed);
    }

    imagesList = rerponseList;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gallery'.toUpperCase(),
        ),
      ),
      body: isLoading
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: imagesList.length,
              itemBuilder: (context, index) {
                return Hero(
                  tag: imagesList[index],
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: Colors.black.withOpacity(.5),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            imagesList[index],
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imagesList[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DogImage extends StatelessWidget {
  const DogImage({
    super.key,
    required this.image,
  });
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: image,
        child: Image.asset(
          image,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
