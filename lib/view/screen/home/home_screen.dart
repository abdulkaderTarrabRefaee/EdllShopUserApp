import 'package:flutter/material.dart';
import 'package:edll_user_app/helper/product_type.dart';
import 'package:edll_user_app/localization/language_constrants.dart';
import 'package:edll_user_app/provider/auth_provider.dart';
import 'package:edll_user_app/provider/banner_provider.dart';
import 'package:edll_user_app/provider/brand_provider.dart';
import 'package:edll_user_app/provider/cart_provider.dart';
import 'package:edll_user_app/provider/category_provider.dart';
import 'package:edll_user_app/provider/featured_deal_provider.dart';
import 'package:edll_user_app/provider/flash_deal_provider.dart';
import 'package:edll_user_app/provider/home_category_product_provider.dart';
import 'package:edll_user_app/provider/product_provider.dart';
import 'package:edll_user_app/provider/splash_provider.dart';
import 'package:edll_user_app/provider/theme_provider.dart';
import 'package:edll_user_app/provider/top_seller_provider.dart';
import 'package:edll_user_app/utill/color_resources.dart';
import 'package:edll_user_app/utill/custom_themes.dart';
import 'package:edll_user_app/utill/dimensions.dart';
import 'package:edll_user_app/utill/images.dart';
import 'package:edll_user_app/view/basewidget/title_row.dart';
import 'package:edll_user_app/view/screen/cart/cart_screen.dart';
import 'package:edll_user_app/view/screen/featureddeal/featured_deal_screen.dart';
import 'package:edll_user_app/view/screen/home/widget/announcement.dart';
import 'package:edll_user_app/view/screen/home/widget/banners_view.dart';
import 'package:edll_user_app/view/screen/home/widget/featured_deal_view.dart';
import 'package:edll_user_app/view/screen/home/widget/featured_product_view.dart';
import 'package:edll_user_app/view/screen/home/widget/flash_deals_view.dart';
import 'package:edll_user_app/view/screen/home/widget/footer_banner.dart';
import 'package:edll_user_app/view/screen/home/widget/home_category_product_view.dart';
import 'package:edll_user_app/view/screen/home/widget/latest_product_view.dart';
import 'package:edll_user_app/view/screen/home/widget/main_section_banner.dart';
import 'package:edll_user_app/view/screen/home/widget/products_view.dart';
import 'package:edll_user_app/view/screen/flashdeal/flash_deal_screen.dart';
import 'package:edll_user_app/view/screen/home/widget/recommended_product_view.dart';
import 'package:edll_user_app/view/screen/product/view_all_product_screen.dart';
import 'package:edll_user_app/view/screen/search/search_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../../provider/localization_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadData(BuildContext context, bool reload) async {
    Provider.of<LocalizationProvider>(context, listen: false);

    Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(reload, context);
    Provider.of<BannerProvider>(context, listen: false)
        .getFooterBannerList(context);
    Provider.of<BannerProvider>(context, listen: false)
        .getMainSectionBanner(context);
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(reload, context);
    Provider.of<HomeCategoryProductProvider>(context, listen: false)
        .getHomeCategoryProductList(reload, context);
    Provider.of<TopSellerProvider>(context, listen: false)
        .getTopSellerList(reload, context);
    //await Provider.of<FlashDealProvider>(context, listen: false).getMegaDealList(reload, context,_languageCode,true);
    Provider.of<BrandProvider>(context, listen: false)
        .getBrandList(reload, context);
    Provider.of<ProductProvider>(context, listen: false)
        .getLatestProductList(1, context, reload: reload);
    Provider.of<ProductProvider>(context, listen: false)
        .getFeaturedProductList('1', context, reload: reload);
    Provider.of<FeaturedDealProvider>(context, listen: false)
        .getFeaturedDealList(reload, context);
    Provider.of<ProductProvider>(context, listen: false)
        .getLProductList('1', context, reload: reload);
    Provider.of<ProductProvider>(context, listen: false)
        .getRecommendedProduct(context);
  }

  void passData(int index, String title) {
    index = index;
    title = title;
  }

  int lang = 0;
  bool singleVendor = false;
  @override
  void initState() {
    lang =
        Provider.of<LocalizationProvider>(context, listen: false).languageIndex;
    print("lang is " + lang.toString());

    super.initState();

    singleVendor = Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .businessMode ==
        "single";
    Provider.of<FlashDealProvider>(context, listen: false)
        .getMegaDealList(true, context, true);

    _loadData(context, false);

    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<CartProvider>(context, listen: false).uploadToServer(context);
      Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
    } else {
      Provider.of<CartProvider>(context, listen: false).getCartData();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> types = [
      getTranslated('new_arrival', context),
      getTranslated('top_product', context),
      getTranslated('best_selling', context),
      getTranslated('discounted_product', context)
    ];
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await _loadData(context, true);
            await Provider.of<FlashDealProvider>(context, listen: false)
                .getMegaDealList(true, context, false);

            return true;
          },
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // App Bar
                  SliverAppBar(
                    floating: true,
                    elevation: 0,
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).highlightColor,
                    title: Image.asset(Images.logo_with_name_image, height: 35),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CartScreen()));
                          },
                          icon: Stack(clipBehavior: Clip.none, children: [
                            Image.asset(
                              Images.cart_arrow_down_image,
                              height: Dimensions.ICON_SIZE_DEFAULT,
                              width: Dimensions.ICON_SIZE_DEFAULT,
                              color: ColorResources.getPrimary(context),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Consumer<CartProvider>(
                                  builder: (context, cart, child) {
                                return CircleAvatar(
                                  radius: 7,
                                  backgroundColor: ColorResources.RED,
                                  child: Text(cart.cartList.length.toString(),
                                      style: titilliumSemiBold.copyWith(
                                        color: ColorResources.WHITE,
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_SMALL,
                                      )),
                                );
                              }),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),

                  // Search Button
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverDelegate(
                          child: InkWell(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SearchScreen())),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.HOME_PAGE_PADDING,
                              vertical: Dimensions.PADDING_SIZE_SMALL),
                          color: ColorResources.getHomeBg(context),
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: Dimensions.HOME_PAGE_PADDING,
                              right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                              top: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                              bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            ),
                            height: 60,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[
                                        Provider.of<ThemeProvider>(context)
                                                .darkTheme
                                            ? 900
                                            : 200],
                                    spreadRadius: 1,
                                    blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(
                                  Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(getTranslated('SEARCH_HINT', context),
                                      style: robotoRegular.copyWith(
                                          color: Theme.of(context).hintColor)),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL))),
                                    child: Icon(Icons.search,
                                        color: Theme.of(context).cardColor,
                                        size: Dimensions.ICON_SIZE_SMALL),
                                  ),
                                ]),
                          ),
                        ),
                      ))),

                  //remove padding
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(
                  //       Dimensions.HOME_PAGE_PADDING,
                  //       Dimensions.PADDING_SIZE_SMALL,
                  //       Dimensions.PADDING_SIZE_DEFAULT,
                  //       Dimensions.PADDING_SIZE_SMALL),

                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        BannersView(),
                        SizedBox(height: Dimensions.HOME_PAGE_PADDING),
                        //remove circule cat
                        // Category
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal:
                        //           Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL,
                        //       vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //   child: TitleRow(
                        //       title: getTranslated('CATEGORY', context),
                        //       onTap: () => Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (_) => AllCategoryScreen(0)))),
                        // ),
                        // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       bottom: Dimensions.HOME_PAGE_PADDING),
                        //   child: CategoryView(isHomePage: true),
                        // ),

                        Consumer<FlashDealProvider>(
                          builder: (context, flashDeal, child) {
                            return (flashDeal.flashDeal != null &&
                                flashDeal.flashDealList != null &&
                                flashDeal.flashDealList.length > 0)
                                ? TitleRow(
                              title:
                              getTranslated('flash_deal', context),
                              eventDuration: flashDeal.flashDeal != null
                                  ? flashDeal.duration
                                  : null,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            FlashDealScreen()));
                              },
                              isFlash: true,
                            )
                                : SizedBox.shrink();
                          },
                        ),

                        //mainSection banner
                        Consumer<BannerProvider>(
                            builder: (context, footerBannerProvider, child) {
                              return footerBannerProvider.mainSectionBannerList !=
                                  null &&
                                  footerBannerProvider
                                      .mainSectionBannerList.length >
                                      0
                                  ? Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: Dimensions.HOME_PAGE_PADDING),
                                  child: Column(
                                    children: [
                                      StaggeredGridView.countBuilder(

                                        physics: BouncingScrollPhysics(),
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 0,
                                        mainAxisSpacing: 0,
                                        itemCount: footerBannerProvider
                                            .mainSectionBannerList.length,
                                        shrinkWrap: true,
                                        staggeredTileBuilder: (int index) =>
                                            StaggeredTile.fit(2),
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          return MainSectionBannersView(
                                            index: index,
                                          );
                                        },
                                      ),
                                    ],
                                  ))
                                  : SizedBox();
                            }),
                        // Mega Deal

                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Consumer<FlashDealProvider>(
                          builder: (context, megaDeal, child) {
                            return (megaDeal.flashDeal != null &&
                                    megaDeal.flashDealList != null &&
                                    megaDeal.flashDealList.length > 0)
                                ? Container(
                                    height:
                                        MediaQuery.of(context).size.width *
                                            1.09,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom:
                                              Dimensions.HOME_PAGE_PADDING),
                                      child: FlashDealsView(),
                                    ))
                                : SizedBox.shrink();
                          },
                        ),

                        // Hide Brand
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        //       right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        //       bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //   child: TitleRow(
                        //       title: getTranslated('brand', context),
                        //       onTap: () {
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (_) => AllBrandScreen()));
                        //       }),
                        // ),
                        // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        // BrandView(isHomePage: true),
                        //remove commend to view seller
                        //top seller

                        //
                        // singleVendor
                        //     ? SizedBox()
                        //     : TitleRow(
                        //         title: getTranslated('top_seller', context),
                        //         onTap: () {
                        //           Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                   builder: (_) => AllTopSellerScreen(
                        //                         topSeller: null,
                        //                       )));
                        //         },
                        //       ),
                        // singleVendor
                        //     ? SizedBox(height: 0)
                        //     : SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        // singleVendor
                        //     ? SizedBox()
                        //     : Padding(
                        //         padding: const EdgeInsets.only(
                        //             bottom: Dimensions.HOME_PAGE_PADDING),
                        //         child: TopSellerView(isHomePage: true),
                        //       ),
                        //


                        // Featured Products
                        Consumer<ProductProvider>(
                            builder: (context, featured, _) {
                          return featured.featuredProductList != null &&
                                  featured.featuredProductList.length > 0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                      vertical: Dimensions
                                          .PADDING_SIZE_EXTRA_SMALL),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom:
                                            Dimensions.PADDING_SIZE_SMALL),
                                    child: TitleRow(
                                        title: getTranslated(
                                            'featured_products', context),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => AllProductScreen(
                                                      productType: ProductType
                                                          .FEATURED_PRODUCT)));
                                        }),
                                  ),
                                )
                              : SizedBox();
                        }),

                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: Dimensions.HOME_PAGE_PADDING),
                          child: FeaturedProductView(
                            scrollController: _scrollController,
                            isHome: true,
                          ),
                        ),

                        // Featured Deal
                        Consumer<FeaturedDealProvider>(
                          builder: (context, featuredDealProvider, child) {
                            return featuredDealProvider.featuredDealList ==
                                    null
                                ? TitleRow(
                                    title: getTranslated(
                                        'featured_deals', context),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  FeaturedDealScreen()));
                                    })
                                : (featuredDealProvider.featuredDealList !=
                                            null &&
                                        featuredDealProvider
                                                .featuredDealList.length >
                                            0)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: Dimensions
                                                .PADDING_SIZE_SMALL),
                                        child: TitleRow(
                                            title: getTranslated(
                                                'featured_deals', context),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          FeaturedDealScreen()));
                                            }),
                                      )
                                    : SizedBox.shrink();
                          },
                        ),

                        Consumer<FeaturedDealProvider>(
                          builder: (context, featuredDeal, child) {
                            return featuredDeal.featuredDealList == null &&
                                    featuredDeal.featuredDealList.length > 0
                                ? Container(
                                    height: 150, child: FeaturedDealsView())
                                : (featuredDeal.featuredDealList != null &&
                                        featuredDeal.featuredDealList.length >
                                            0)
                                    ? Container(
                                        height: featuredDeal
                                                    .featuredDealList.length >
                                                4
                                            ? 120 * 4.0
                                            : 120 *
                                                (double.parse(featuredDeal
                                                    .featuredDealList.length
                                                    .toString())),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: Dimensions
                                                  .HOME_PAGE_PADDING),
                                          child: FeaturedDealsView(),
                                        ))
                                    : SizedBox.shrink();
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: Dimensions.HOME_PAGE_PADDING),
                          child: RecommendedProductView(),
                        ),

                        // Latest Products
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: TitleRow(
                              title:
                                  getTranslated('latest_products', context),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AllProductScreen(
                                            productType:
                                                ProductType.LATEST_PRODUCT)));
                              }),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        LatestProductView(
                            scrollController: _scrollController),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        //Home category
                        HomeCategoryProductView(isHomePage: true),
                        SizedBox(height: Dimensions.HOME_PAGE_PADDING),

                        //footer banner
                        Consumer<BannerProvider>(
                            builder: (context, footerBannerProvider, child) {
                          return footerBannerProvider.footerBannerList !=
                                      null &&
                                  footerBannerProvider
                                          .footerBannerList.length >
                                      0
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: Dimensions.HOME_PAGE_PADDING),
                                  child: Column(
                                    children: [
                                      StaggeredGridView.countBuilder(

                                        physics: BouncingScrollPhysics(),
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10,
                                        itemCount: footerBannerProvider
                                            .footerBannerList.length,
                                        shrinkWrap: true,
                                        staggeredTileBuilder: (int index) =>
                                            StaggeredTile.fit(2),
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          return FooterBannersView(
                                            index: index,
                                          );
                                        },
                                      ),
                                    ],
                                  ))
                              : SizedBox();
                        }),

                        SizedBox(height: Dimensions.HOME_PAGE_PADDING),

                        //Category filter
                        Consumer<ProductProvider>(
                            builder: (ctx, prodProvider, child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                vertical:
                                    Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Row(children: [
                              Expanded(
                                  child: Text(
                                      prodProvider.title == 'xyz'
                                          ? getTranslated(
                                              'new_arrival', context)
                                          : prodProvider.title,
                                      style: titleHeader)),
                              prodProvider.latestProductList != null
                                  ? PopupMenuButton(
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                              value: ProductType.NEW_ARRIVAL,
                                              child: Text(getTranslated(
                                                  'new_arrival', context)),
                                              textStyle:
                                                  robotoRegular.copyWith(
                                                color: Theme.of(context)
                                                    .hintColor,
                                              )),
                                          PopupMenuItem(
                                              value: ProductType.TOP_PRODUCT,
                                              child: Text(getTranslated(
                                                  'top_product', context)),
                                              textStyle:
                                                  robotoRegular.copyWith(
                                                color: Theme.of(context)
                                                    .hintColor,
                                              )),
                                          PopupMenuItem(
                                              value: ProductType.BEST_SELLING,
                                              child: Text(getTranslated(
                                                  'best_selling', context)),
                                              textStyle:
                                                  robotoRegular.copyWith(
                                                color: Theme.of(context)
                                                    .hintColor,
                                              )),
                                          PopupMenuItem(
                                              value: ProductType
                                                  .DISCOUNTED_PRODUCT,
                                              child: Text(getTranslated(
                                                  'discounted_product',
                                                  context)),
                                              textStyle:
                                                  robotoRegular.copyWith(
                                                color: Theme.of(context)
                                                    .hintColor,
                                              )),
                                        ];
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.PADDING_SIZE_SMALL)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_SMALL,
                                            vertical: Dimensions
                                                .PADDING_SIZE_SMALL),
                                        child: Image.asset(
                                          Images.dropdown,
                                          scale: 3,
                                        ),
                                      ),
                                      onSelected: (value) {
                                        if (value ==
                                            ProductType.NEW_ARRIVAL) {
                                          Provider.of<ProductProvider>(
                                                  context,
                                                  listen: false)
                                              .changeTypeOfProduct(
                                                  value, types[0]);
                                        } else if (value ==
                                            ProductType.TOP_PRODUCT) {
                                          Provider.of<ProductProvider>(
                                                  context,
                                                  listen: false)
                                              .changeTypeOfProduct(
                                                  value, types[1]);
                                        } else if (value ==
                                            ProductType.BEST_SELLING) {
                                          Provider.of<ProductProvider>(
                                                  context,
                                                  listen: false)
                                              .changeTypeOfProduct(
                                                  value, types[2]);
                                        } else if (value ==
                                            ProductType.DISCOUNTED_PRODUCT) {
                                          Provider.of<ProductProvider>(
                                                  context,
                                                  listen: false)
                                              .changeTypeOfProduct(
                                                  value, types[3]);
                                        }

                                        ProductView(
                                            isHomePage: false,
                                            productType: value,
                                            scrollController:
                                                _scrollController);
                                        Provider.of<ProductProvider>(context,
                                                listen: false)
                                            .getLatestProductList(1, context,
                                                reload: true);
                                      })
                                  : SizedBox(),
                            ]),
                          );
                        }),
                        ProductView(
                            isHomePage: false,
                            productType: ProductType.NEW_ARRIVAL,
                            scrollController: _scrollController),
                        SizedBox(height: Dimensions.HOME_PAGE_PADDING),
                      ],
                    ),
                  )
                ],
              ),
              Provider.of<SplashProvider>(context, listen: false)
                          .configModel
                          .announcement
                          .status ==
                      '1'
                  ? Positioned(
                      top: MediaQuery.of(context).size.height - 70,
                      left: 0,
                      right: 0,
                      child: Consumer<SplashProvider>(
                        builder: (context, announcement, _) {
                          return announcement.onOff
                              ? AnnouncementScreen(
                                  announcement:
                                      announcement.configModel.announcement)
                              : SizedBox();
                        },
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 70 ||
        oldDelegate.minExtent != 70 ||
        child != oldDelegate.child;
  }
}
