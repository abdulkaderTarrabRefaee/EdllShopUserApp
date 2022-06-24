// ignore_for_file: must_be_immutable

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
import '../../basewidget/no_internet_screen.dart';
import '../../basewidget/product_shimmer.dart';
import '../../basewidget/product_widget.dart';

class CategoryProductScreen extends StatelessWidget {
  int id;
  CategoryProductScreen(this.id);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(false, (this.id+1).toString(), context);

    Provider.of<CategoryProvider>(context, listen: false)
        .changeSelectedIndex(this.id);

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body:
      Column(
        children: [
          CustomAppBar(title: getTranslated('CATEGORY', context)),
          Expanded(
            flex:0,
              child:
          Consumer<CategoryProvider>(

            builder: (context, categoryProvider, child) {


              return categoryProvider.categoryList.length != 0
                  ? Column(children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 3),
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 700
                                        : 200],
                                spreadRadius: 1,
                                blurRadius: 1)
                          ],
                        ),
                        child: ListView.builder(

                          physics: BouncingScrollPhysics(),
                          itemCount: categoryProvider.categoryList.length ,
                          padding: EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            SubCategory _subCategory;



                            Category _category =
                                categoryProvider.categoryList[index];
                            return InkWell(
                              onTap: () {
                                Provider.of<CategoryProvider>(context,
                                        listen: false)
                                    .changeSelectedIndex(index);
                                Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(false, (categoryProvider
                                    .categoryList[categoryProvider
                                    .categorySelectedIndex]
                                    .id).toString(), context);
                              },
                              child: CategoryItem(
                                title: _category.name,
                                icon: _category.icon,
                                isSelected:
                                    categoryProvider.categorySelectedIndex ==
                                        index,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 3),
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[
                                Provider.of<ThemeProvider>(context)
                                    .darkTheme
                                    ? 700
                                    : 200],
                                spreadRadius: 1,
                                blurRadius: 1)
                          ],
                        ),


                        child: Expanded(
                            child: ListView.builder(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          itemExtent: 150.1,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                          itemCount: categoryProvider
                                  .categoryList[
                                      categoryProvider.categorySelectedIndex]
                                  .subCategories
                                  .length +
                              1,
                          itemBuilder: (context, index) {
                            SubCategory _subCategory;
                            if (index != 0) {
                              _subCategory = categoryProvider
                                  .categoryList[
                                      categoryProvider.categorySelectedIndex]
                                  .subCategories[index - 1];
                            }
                            if (index == 0) {
                              return InkWell(
                                onTap: () {
                                  Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(false, (categoryProvider
                                      .categoryList[categoryProvider
                                      .categorySelectedIndex]
                                      .id).toString(), context);


                                },
                                child: Row(
                                  children: [
                                    Text( categoryProvider.categoryList[ categoryProvider.categorySelectedIndex].name +" " + getTranslated('all', context) ,
                                        style: titilliumSemiBold,

                                        overflow: TextOverflow.ellipsis),

                                  ],
                                ),
                              );
                            } else {
                              return InkWell(
                                child: Row(
                                  children: [
                                    Text(_subCategory.name,
                                        style: titilliumSemiBold,

                                        overflow: TextOverflow.ellipsis),

                                  ],
                                ),
                                onTap: () {
                                  Provider.of<ProductProvider>(context, listen: false).initBrandOrCategoryProductList(false, _subCategory.id.toString(), context);

                                },
                              );
                            }
                          },

                        )

                        ),
                      ),
                    ])
                  : Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)));
            },
          )
          ),
          Expanded(child: Consumer<ProductProvider>(
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
          ),)

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
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                fit: BoxFit.cover,
                image:
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/$icon',
                imageErrorBuilder: (c, o, s) =>
                    Image.asset(Images.placeholder, fit: BoxFit.cover),
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
