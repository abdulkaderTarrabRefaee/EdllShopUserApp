import 'package:flutter/material.dart';
import 'package:edll_user_app/data/model/response/product_model.dart';
import 'package:edll_user_app/provider/banner_provider.dart';
import 'package:edll_user_app/provider/brand_provider.dart';
import 'package:edll_user_app/provider/category_provider.dart';
import 'package:edll_user_app/provider/splash_provider.dart';
import 'package:edll_user_app/provider/top_seller_provider.dart';
import 'package:edll_user_app/utill/images.dart';
import 'package:edll_user_app/view/screen/product/brand_and_category_product_screen.dart';
import 'package:edll_user_app/view/screen/product/product_details_screen.dart';
import 'package:edll_user_app/view/screen/topSeller/top_seller_product_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';
class FooterBannersView extends StatelessWidget {
  final int index;
  const FooterBannersView({Key key, this.index}) : super(key: key);

  _clickBannerRedirect(BuildContext context, int id, Product product,  String type){

    final cIndex =  Provider.of<CategoryProvider>(context, listen: false).categoryList.indexWhere((element) => element.id == id);
    final bIndex =  Provider.of<BrandProvider>(context, listen: false).brandList.indexWhere((element) => element.id == id);
    final tIndex =  Provider.of<TopSellerProvider>(context, listen: false).topSellerList.indexWhere((element) => element.id == id);


    if(type == 'category'){
      if(Provider.of<CategoryProvider>(context, listen: false).categoryList[cIndex].name != null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
          isBrand: false,
          id: id.toString(),
          name: '${Provider.of<CategoryProvider>(context, listen: false).categoryList[cIndex].name}',
        )));
      }

    }else if(type == 'product'){
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetails(
        product: product,
      )));

    }else if(type == 'brand'){
      if(Provider.of<BrandProvider>(context, listen: false).brandList[bIndex].name != null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
          isBrand: true,
          id: id.toString(),
          name: '${Provider.of<BrandProvider>(context, listen: false).brandList[bIndex].name}',
        )));
      }

    }else if( type == 'shop'){
      if(Provider.of<TopSellerProvider>(context, listen: false).topSellerList[tIndex].name != null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(
          topSellerId: id,
          topSeller: Provider.of<TopSellerProvider>(context,listen: false).topSellerList[tIndex],
        )));
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    Consumer<BannerProvider>(
    builder: (context, footerBannerProvider, child) {

      return InkWell(
        onTap: () {
          Provider.of<BannerProvider>(context, listen: false).getProductDetails(context, footerBannerProvider.mainBannerList[index].resourceId.toString());
          _clickBannerRedirect(context, footerBannerProvider.mainBannerList[index].resourceType=='product'?footerBannerProvider.mainBannerList[index].product.id :footerBannerProvider.mainBannerList[index].resourceId,footerBannerProvider.mainBannerList[index].resourceType =='product'?footerBannerProvider.mainBannerList[index].product : null, footerBannerProvider.mainBannerList[index].resourceType);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width/2.2,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child:  CachedNetworkImage(
                fit:BoxFit.fitWidth ,
                imageUrl: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.bannerImageUrl}'
                    '/${footerBannerProvider.footerBannerList[index].photo}',
                placeholder: (BuildContext context, String url) => Container(

                  child:  Image.asset(Images.placeholder, fit: BoxFit.cover),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_outlined ,color: Color(0x51000000)),

              ),


            ),
          ),
        ),
      );

    },
    ),
      ],
    );
  }


}

