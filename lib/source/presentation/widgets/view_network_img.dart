import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../utils/app_color.dart';

class ViewNetworkImg extends StatelessWidget {
  const ViewNetworkImg({Key? key, required this.imgUrl, required this.fit})
      : super(key: key);
  final String imgUrl;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      fit: fit,
      height: 180,
      progressIndicatorBuilder:
          (BuildContext context, String url, DownloadProgress progress) =>
              Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
              color: AppColors.primaryColor.parseColor(),
              value: progress.progress),
        ),
      ),
      errorWidget: (context, url, error) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            AppLocalizations.of(context)!.something_went_wrong,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, overflow: TextOverflow.fade),
          )
        ],
      ),
    );
  }
}
