import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;

  const ImageDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: Container(
              //width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
              top: 140,
              right: -7,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.red.shade500),
                    child: Icon(Icons.close_sharp, color: Colors.white)),
              )),
        ],
      ),
    );
  }
}
