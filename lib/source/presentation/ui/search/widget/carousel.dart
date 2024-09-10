import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/data/model/home/home_page_int_res.dart';
import 'package:ju_express/source/utils/app_color.dart';
import 'package:photo_view/photo_view.dart';

import '../../../widgets/view_network_img.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({Key? key, required this.items}) : super(key: key);
  final List<BannerItem> items;
  @override
  Widget build(BuildContext context) {
    return items.isNotEmpty
        ? CarouselSlider.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int itemIndex,
                    int pageViewIndex) =>
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 3.0, right: 3, bottom: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(blurRadius: 5, color: Colors.black26)
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: items[itemIndex].banImage != null &&
                            items[itemIndex].banImage!.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>FullScreenImage(image: items[itemIndex].banImage!, tag: itemIndex.toString())));
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        insetPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 5),
                                        backgroundColor: Colors.black,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, right: 5, bottom: 5),
                                              decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle),
                                              child: IconButton(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: items[itemIndex]
                                                      .banImage!,
                                                  fit: BoxFit.cover,
                                                  imageBuilder: (context,
                                                          image) =>
                                                      PhotoView(
                                                          maxScale:
                                                              PhotoViewComputedScale
                                                                  .covered,
                                                          minScale:
                                                              PhotoViewComputedScale
                                                                  .contained,
                                                          imageProvider: image),
                                                  progressIndicatorBuilder:
                                                      (BuildContext context,
                                                              String url,
                                                              DownloadProgress
                                                                  progress) =>
                                                          Center(
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: CircularProgressIndicator(
                                                          color: HexColor(
                                                              AppColors
                                                                  .primaryColor),
                                                          value: progress
                                                              .progress),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.error,
                                                        color: HexColor(
                                                            AppColors
                                                                .primaryColor),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .something_went_wrong,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                            },
                            child: ViewNetworkImg(
                              imgUrl: items[itemIndex].banImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
            options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                viewportFraction: .9,
                height: 180,
                aspectRatio: 15 / 9))
        : Container();
  }
}
