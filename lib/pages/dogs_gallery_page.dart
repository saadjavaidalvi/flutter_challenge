import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/middlewares/dog_breeds.dart';
import 'package:flutter_challenge/utils/custom_strings.dart';
import 'package:flutter_challenge/utils/skeleton_loading.dart';

/// A Gallery Page for the dog where you can view all of the dogs pictures
///
/// You can scale each image by tapping on the them
///
/// the [subbreed] is an optional field
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
    imagesMiddlwareCall();
  }

  /// Calls for the list to images
  ///
  /// Furthure it handle which endpoint to call based if sub-breed is provided or not
  Future<void> imagesMiddlwareCall() async {
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
          CustomStrigns().galleryTitle.toUpperCase(),
        ),
      ),
      body: isLoading
          ? loadingState()
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: imagesList.length,
              itemBuilder: (context, index) {
                return gridViewItem(imagesList[index]);
              },
            ),
    );
  }

  Widget loadingState() {
    return const Column(
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
    );
  }

  Widget gridViewItem(String image) {
    return Hero(
      tag: image,
      child: GestureDetector(
        onTap: () {
          onTapActionForGridView(image);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: image,
              placeholder: (context, url) => const Skeleton(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
      ),
    );
  }

  void onTapActionForGridView(String image) {
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
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          image,
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
  }
}
