import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:edll_user_app/localization/language_constrants.dart';
import 'package:edll_user_app/utill/custom_themes.dart';
import 'package:edll_user_app/utill/dimensions.dart';
import 'package:edll_user_app/view/basewidget/title_row.dart';
import 'package:edll_user_app/view/screen/product/specification_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductSpecification extends StatelessWidget {
  final String productSpecification;
  ProductSpecification({@required this.productSpecification});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    return Column(
      children: [
        TitleRow(title: getTranslated('specification', context), isDetailsPage: true,

        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        productSpecification.isNotEmpty ? Expanded(child: Html(data: productSpecification)) :
        Center(child: Text('No specification')),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
        InkWell(
              onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => SpecificationScreen(specification: productSpecification)));
          },
            child: Text(getTranslated('view_full_detail', context), style: titleRegular.copyWith(color: Theme.of(context).primaryColor),))

      ],
    );
  }
}
