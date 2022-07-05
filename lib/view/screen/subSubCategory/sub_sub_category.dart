
import 'package:flutter/material.dart';
import 'package:edll_user_app/data/model/response/category.dart';
import 'package:edll_user_app/localization/language_constrants.dart';
import 'package:edll_user_app/provider/category_provider.dart';
import 'package:edll_user_app/provider/splash_provider.dart';
import 'package:edll_user_app/provider/theme_provider.dart';
import 'package:edll_user_app/utill/color_resources.dart';
import 'package:edll_user_app/utill/custom_themes.dart';
import 'package:edll_user_app/utill/dimensions.dart';
import 'package:edll_user_app/utill/images.dart';
import 'package:edll_user_app/view/basewidget/custom_app_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../../provider/product_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../basewidget/no_internet_screen.dart';
import '../../basewidget/product_shimmer.dart';
import '../../basewidget/product_widget.dart';

// ignore: must_be_immutable
class SubSubCat extends StatelessWidget {
  int id;
  SubCategory _subCategory;
  SubSubCat(this.id, this._subCategory);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(false, (this.id).toString(), context);




    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body:
      Column(
        children: [
          CustomAppBar(title:_subCategory.name),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 3),
            height: 110,

            child: Consumer<CategoryProvider>(

              builder: (context, categoryProvider, child) {


                return categoryProvider.categoryList.length != 0
                    ? Column(children: [

                      //SubSubCategory
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 3),
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.red[
                            Provider.of<ThemeProvider>(context)
                                .darkTheme
                                ? 700
                                : 100],
                            spreadRadius: 1,
                            blurRadius: 1)
                      ],
                    ),



                    child: ListView.builder(
                      padding:  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      itemExtent: 150.1,

                      scrollDirection: Axis.horizontal,
                      itemCount: _subCategory.subSubCategories.length,
                      itemBuilder: (context, index) {

                        if (index == 0) {
                          return InkWell(
                            onTap: () {

                              Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(false, (categoryProvider.categorySelectedIndex).toString(), context);

                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color:  Theme.of(context).hintColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      fit:BoxFit.fitWidth ,
                                      imageUrl: Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl+"/"+_subCategory.icon,
                                      placeholder: (BuildContext context, String url) => Container(

                                        child:  Image.asset(Images.placeholder, fit: BoxFit.cover),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_outlined ,color: Color(0x51000000)),

                                    ),
                                  ),
                                ),
                                Text( _subCategory.name +" " + getTranslated('all', context) ,
                                    style: titilliumSemiBold,

                                    overflow: TextOverflow.ellipsis),


                              ],
                            ),
                          );
                        }
                        else
                          return InkWell(
                            onTap: () {
                              Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(false, (_subCategory.subSubCategories[index]
                                  .id).toString(), context);


                            },
                            child: Column(
                              children: [
                                Container(

                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color:  Theme.of(context).hintColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                   ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                     child: CachedNetworkImage(
                                    fit:BoxFit.cover ,
                                    imageUrl: Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl+"/"+_subCategory.subSubCategories[ index].icon,
                                    placeholder: (BuildContext context, String url) => Container(

                                      child:  Image.asset(Images.placeholder, fit: BoxFit.cover),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_outlined ,color: Color(0x51000000)),

                                  ),
                                ),),
                                Text( _subCategory.subSubCategories[ index].name ,
                                    style: titilliumSemiBold,

                                    overflow: TextOverflow.ellipsis),

                              ],
                            ),
                          );
                        }


                    ),
                  ),
                ])
                    : Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)));
              },
            ),
          ),

          //products
          Expanded(

            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {

                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                  productProvider.brandOrCategoryProductList.length > 0 ? Expanded(
                    child: StaggeredGridView.countBuilder(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      itemCount: productProvider.brandOrCategoryProductList.length,
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductWidget(productModel: productProvider.brandOrCategoryProductList[index]);
                      },
                    ),
                  )
                      : Expanded(child: Center(child: productProvider.hasData
                      ? ProductShimmer(isHomePage: false,isEnabled: Provider.of<ProductProvider>(context).brandOrCategoryProductList.length == 0)
                      : NoInternetOrDataScreen(isNoInternet: false),
                  )),

                ]);
              },
            ),
          )

        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;
  CategoryItem(
      {@required this.title, @required this.icon, @required this.isSelected});

  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? ColorResources.getPrimary(context) : null,
      ),
      child: Center(
        child:
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: isSelected
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).hintColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:  CachedNetworkImage(
                fit:BoxFit.fitWidth ,
                imageUrl:'${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/$icon',
                placeholder: (BuildContext context, String url) => Container(

                  child:  Image.asset(Images.placeholder, fit: BoxFit.cover),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_outlined ,color: Color(0x51000000)),

              ),



            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: titilliumSemiBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  color: isSelected
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).hintColor,
                )),
          ),
        ]),
      ),
    );
  }
}
