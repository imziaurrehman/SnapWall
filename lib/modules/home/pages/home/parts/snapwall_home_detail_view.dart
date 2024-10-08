import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapwall/configs/color/color.dart';
import 'package:snapwall/configs/components/back_widget.dart';
import 'package:snapwall/configs/components/components_exports.dart';
import 'package:snapwall/configs/components/fade_transition_widget.dart';
import 'package:snapwall/configs/components/title2_text_widget.dart';
import 'package:snapwall/core/utils/extensions/general_ectensions.dart';
import 'package:snapwall/modules/home/models/trend_photos_model.dart';
import 'package:snapwall/modules/home/pages/home/parts/network_cache_image.dart';
import 'package:snapwall/modules/home/pages/home/parts/wallpaper_detail_preview.dart';
import 'package:snapwall/modules/search/models/search_photos_model.dart';
import 'snapwall_home_header_view.dart';

class SnapWallHomeDetailView extends StatelessWidget {
  SnapWallHomeDetailView({
    super.key,
    this.photosModel,
    this.photosDetailsSearchModel,
  });
  final PhotosModel? photosModel;
  final PhotosDetailsSearchModel? photosDetailsSearchModel;
  final Rx<bool> isLoading = Rx<bool>(false);

  @override
  Widget build(BuildContext context) {
    // Use photosModel or photosDetailsSearchModel depending on the context
    String imageUrl = photosModel?.src.portrait ??
        photosDetailsSearchModel?.src.portrait ??
        '';
    String photographer = photosModel?.photographer ??
        photosDetailsSearchModel?.photographer ??
        '';
    String alt = photosModel?.alt ?? photosDetailsSearchModel?.alt ?? '';
    int width = photosModel?.width ?? photosDetailsSearchModel?.width ?? 0;
    int height = photosModel?.height ?? photosDetailsSearchModel?.height ?? 0;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenProportionBox(
              height: .02,
            ),
            // custom back button
            const BackWidget(),

            const ScreenProportionBox(
              height: .03,
            ),

            // HEADER SECTION (TITLE, SHARE & FAV)

            const FadeTransitionWidget(
              delay: 1000,
              child: SnapWallHeaderView(
                title1: 'SnapWall ',
                title2: '\tDetail',
                title2FontWeight: FontWeight.w500,
                navTabIndexIconImgBtn1: 3,
                // onTap1: () => Navigator.pop,
                icon1: CupertinoIcons.heart,
                image2: 'assets/icons/share.png',
                isIcon1: true,
                isIcon2: false,
              ),
            ),
            // ShareImageWidget(
            //   imagePath: imageUrl,
            // ),

            const ScreenProportionBox(
              height: .02,
            ),

            // COVER IMAGE SECTION
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                child: NetworkCacheImageWithTransitionEffect(
                  imageUrl: imageUrl,
                ),
              ),
            ),

            const ScreenProportionBox(
              height: .02,
            ),

            // IMAGE DETAIL SECTION

            // image author text
            FadeTransitionWidget(
              delay: 1200,
              duration: 500,
              child: SnapWallDetailDescription(
                photographer: photographer,
                alt: alt,
                width: width,
                height: height,
              ),
            ),

            ScreenProportionBox(
              height: alt.isNotEmpty ? .02 : .02,
            ),

            // BUTTONS SECTIONS (PREVIEW & DOWNLOAD)
            Obx(() {
              return FadeTransitionWidget(
                delay: 1550,
                child: RoundButton(
                  loading: isLoading.value,
                  title: 'Preview',
                  onPress: () {
                    debugPrint('Preview is Pressed!');
                    isLoading.value = true;
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      isLoading.value = false;
                      Get.to(SnapWallWallpaperDetailPreview(
                        photosModel: photosModel,
                        photosDetailsSearchModel: photosDetailsSearchModel,
                      ));
                    });
                  },
                ),
              );
            }),

            const ScreenProportionBox(
              height: .01,
            ),

            Center(
              child: FadeTransitionWidget(
                delay: 1800,
                child: RoundButton(
                  loading: false,
                  title: 'Download',
                  onPress: () {
                    debugPrint('Download is Pressed!');
                  },
                ),
              ),
            ),
          ],
        ).paddingSymmetric(
          horizontal: context.mqw * .04,
          vertical: context.mqh * .04,
        ),
      ),
    );
  }

  // share method
}

class SnapWallDetailDescription extends StatelessWidget {
  const SnapWallDetailDescription({
    super.key,
    required this.photographer,
    required this.alt,
    required this.width,
    required this.height,
  });

  final String photographer;
  final String alt;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Title2TextWidget(
          titlePart1: 'Author:\t',
          titlePart2: photographer,
          weightT2: FontWeight.w500,
          size: 14,
        ),
        const DividerHorizontalWidget(),

        // image alt text

        Title2TextWidget(
          titlePart1: alt.isEmpty ? 'Size:' : 'Alt:\t',
          titlePart2: alt.isEmpty
              ? '${width.toString()} x ${height.toString()} px'
              : alt,
          size: 14,
          weightT2: FontWeight.w500,
        ),

        if (alt.isNotEmpty) const DividerHorizontalWidget(),

        // image size text

        Title2TextWidget(
          titlePart1: alt.isNotEmpty ? 'Size:' : '',
          titlePart2: alt.isNotEmpty
              ? '${width.toString()} x ${height.toString()} px'
              : '',
          size: 14,
          weightT2: FontWeight.w500,
        ),
      ],
    );
  }
}

class DividerHorizontalWidget extends StatelessWidget {
  const DividerHorizontalWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.grey,
      thickness: .2,
      height: 3.5,
      indent: 1.0,
      endIndent: 10.0,
    );
  }
}
