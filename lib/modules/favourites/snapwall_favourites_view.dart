import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapwall/configs/color/color.dart';
import 'package:snapwall/configs/components/components_exports.dart';
import 'package:snapwall/configs/components/loading_widget.dart';
import 'package:snapwall/core/utils/extensions/general_ectensions.dart';
import 'package:snapwall/core/utils/helper_get_controllers/favourites_controller.dart';
import 'package:snapwall/data/response/status.dart';
import 'package:snapwall/modules/favourites/parts/empty_favourite_widget.dart';
import 'package:snapwall/modules/favourites/parts/favourites_photos_grid.dart';
import 'package:snapwall/modules/home/h_controller/home_controller.dart';
import 'package:snapwall/modules/home/pages/home/parts/snapwall_home_header_view.dart';

class SnapWallFavouritesView extends StatelessWidget {
  SnapWallFavouritesView({
    super.key,
  });

  final FavouritesXController favouritesXController = Get.put(
    FavouritesXController(),
  );
  final TrendXController trendXController = Get.put(
    TrendXController(),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenProportionBox(
              height: .02,
            ),
            // header section

            const SnapWallHeaderView(
              title1: 'Wallpaper',
              title2: '\tPicks',
              navTabIndexIconImgBtn1: 2,
              navTabIndexIconImgBtn2: 1,
              isIcon1: false,
              isIcon2: true,
              image1: 'assets/icons/search.png',
              icon2: CupertinoIcons.square_grid_2x2,
              title1Color: AppColors.red,
              title2Color: AppColors.grey,
              title1FontWeight: FontWeight.w500,
              title2FontWeight: FontWeight.normal,
            ),

            // const LogoTextWidget(
            //   title1: 'Wallpaper',
            //   title2: '\tPicks',
            //   title2Color: AppColors.grey,
            //   title1Color: AppColors.red,
            //   title1FontWeight: FontWeight.w500,
            //   title2FontWeight: FontWeight.normal,
            // ),

            // favourites sections view

            Expanded(
              child: Obx(() {
                if (trendXController.trendPhotos.value.status ==
                    Status.loading) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                } else if (trendXController.trendPhotos.value.status ==
                    Status.error) {
                  return Center(
                    child: Text(
                      trendXController.trendPhotos.value.message!,
                    ),
                  );
                }
                return favouritesXController.likedPhotos.value.isEmpty
                    ? const EmptyFavouriteWidget()
                    : FavouritesPhotosGrid(
                        data: favouritesXController.likedPhotos.value ?? [],
                        favouritesXController: favouritesXController,
                      );
              }),
            ),
          ],
        ).paddingSymmetric(
          horizontal: context.mqw * .04,
          vertical: context.mqh * .01,
        ),
      ),
    );
  }
}
