
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:edll_user_app/localization/language_constrants.dart';
import 'package:edll_user_app/utill/color_resources.dart';
import 'package:edll_user_app/utill/custom_themes.dart';
import 'package:edll_user_app/utill/dimensions.dart';
import 'package:provider/provider.dart';
import '../../../../data/model/response/user_info_model.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/profile_provider.dart';
import '../../auth/auth_screen.dart';

class DeleteAccountDialog extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 50),
          child: Text(getTranslated('want_to_delete_your_account', context), style: robotoBold, textAlign: TextAlign.center),
        ),

        Divider(height: 0, color: ColorResources.HINT_TEXT_COLOR),
        Row(children: [

          Expanded(child: InkWell(
            onTap: () async {
              UserInfoModel updateUserInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
              File file;

              updateUserInfoModel.method = 'put';
              updateUserInfoModel.fName = "";
              updateUserInfoModel.lName = "";
              updateUserInfoModel.phone = "";
              updateUserInfoModel.email = "";
              String pass = "";
              await Provider.of<ProfileProvider>(context, listen: false).updateUserInfo(
                updateUserInfoModel, pass,file, Provider.of<AuthProvider>(context, listen: false).getUserToken(),
              );
              Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
                Navigator.pop(context);
                Provider.of<ProfileProvider>(context,listen: false).clearHomeAddress();
                Provider.of<ProfileProvider>(context,listen: false).clearOfficeAddress();
                Provider.of<AuthProvider>(context,listen: false).clearSharedData();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthScreen()), (route) => false);
              });
            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(getTranslated('YES', context), style: titilliumBold.copyWith(color: Theme.of(context).primaryColor)),
            ),
          )),

          Expanded(child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: ColorResources.RED, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(getTranslated('NO', context), style: titilliumBold.copyWith(color: ColorResources.WHITE)),
            ),
          )),

        ]),
      ]),
    );
  }
}
