import 'dart:io';

import 'package:flutter/material.dart';
import 'package:edll_user_app/data/model/response/social_login_model.dart';
import 'package:edll_user_app/localization/language_constrants.dart';
import 'package:edll_user_app/provider/auth_provider.dart';
import 'package:edll_user_app/provider/facebook_login_provider.dart';
import 'package:edll_user_app/provider/google_sign_in_provider.dart';
import 'package:edll_user_app/provider/splash_provider.dart';
import 'package:edll_user_app/provider/theme_provider.dart';
import 'package:edll_user_app/utill/images.dart';
import 'package:edll_user_app/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'mobile_verify_screen.dart';
import 'otp_verification_screen.dart';
import 'dart:io';



import 'package:http/http.dart' as http;

class SocialLoginWidget extends StatefulWidget {
  @override
  _SocialLoginWidgetState createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {

  SocialLoginModel socialLogin = SocialLoginModel();
  route(bool isRoute, String token, String temporaryToken, String errorMessage) async {
    if (isRoute) {
      if(token != null){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);

      }else if(temporaryToken != null && temporaryToken.isNotEmpty){
        if(Provider.of<SplashProvider>(context,listen: false).configModel.emailVerification){
          Provider.of<AuthProvider>(context, listen: false).checkEmail(socialLogin.email.toString(),temporaryToken).then((value) async {
            if (value.isSuccess) {
              Provider.of<AuthProvider>(context, listen: false).updateEmail(socialLogin.email.toString());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => VerificationScreen(temporaryToken,'',socialLogin.email.toString())), (route) => false);

            }
          });
        }
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MobileVerificationScreen(temporaryToken)), (route) => false);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Provider.of<SplashProvider>(context,listen: false).configModel.socialLogin[0].status?
        Provider.of<SplashProvider>(context,listen: false).configModel.socialLogin[1].status?
        Center(child: Text(getTranslated('social_login', context)))
            :Center(child: Text(getTranslated('social_login', context))):SizedBox(),
        Container(color: Provider.of<ThemeProvider>(context).darkTheme ? Theme.of(context).canvasColor : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              if (Platform.isIOS)
                Container(
                  height: 50,
                  width: 250,
                  child: AppleSignInButton(
                    onPressed: logIn,
                  ),
                )

              else
                SizedBox(),
              Provider.of<SplashProvider>(context,listen: false).configModel.socialLogin[0].status?

              InkWell(
                onTap: () async{

                  await Provider.of<GoogleSignInProvider>(context, listen: false).login();
                  String id,token,email, medium;
                  if(Provider.of<GoogleSignInProvider>(context,listen: false).googleAccount != null){
                    id = Provider.of<GoogleSignInProvider>(context,listen: false).googleAccount.id;
                    email = Provider.of<GoogleSignInProvider>(context,listen: false).googleAccount.email;
                    token = Provider.of<GoogleSignInProvider>(context,listen: false).auth.accessToken;
                    medium = 'google';

                    socialLogin.email = email;
                    socialLogin.medium = medium;
                    socialLogin.token = token;
                    socialLogin.uniqueId = id;
                    print('===>info ===> $email   ====> $medium ====> $token   ==>$id');
                    await Provider.of<AuthProvider>(context, listen: false).socialLogin(socialLogin, route);


                  }

                },
                child: Ink(
                  color: Color(0xFF397AF3),
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Card(
                      // color: Color(0xFF397AF3),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white ,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                height: 30,width: 30,
                                child: Image.asset(Images.google)), // <-- Use 'Image.asset(...)' here
                            // SizedBox(width: 12),
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(0,8,8,8),
                            //   child: Text('Google',maxLines: 2, style: TextStyle(color: Colors.white),),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ) :SizedBox(),

              Provider.of<SplashProvider>(context,listen: false).configModel.socialLogin[1].status?
              InkWell(
                onTap: () async{
                  await Provider.of<FacebookLoginProvider>(context, listen: false).login();

                  String id,token,email, medium;
                  if(Provider.of<FacebookLoginProvider>(context,listen: false).userData != null){
                    id = Provider.of<FacebookLoginProvider>(context,listen: false).result.accessToken.userId;
                    email = Provider.of<FacebookLoginProvider>(context,listen: false).userData['email'];
                    token = Provider.of<FacebookLoginProvider>(context,listen: false).result.accessToken.token;
                    medium = 'facebook';

                    socialLogin.email = email;
                    socialLogin.medium = medium;
                    socialLogin.token = token;
                    socialLogin.uniqueId = id;
                    print('===>info ===> $email   ====> $medium ====> $token   ==>$id');

                    await Provider.of<AuthProvider>(context, listen: false).socialLogin(socialLogin, route);

                  }

                },
                child: Ink(
                  color: Color(0xFF397AF3),
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(height: 30,width: 30,
                                child: Image.asset(Images.facebook)), // <-- Use 'Image.asset(...)' here
                            // SizedBox(width: 8),
                            // Text('Facebook',maxLines: 2,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ):SizedBox(),


            ],
          ),
        ),
      ],
    );
  }
}
void logIn() async {
  final AuthorizationResult result = await TheAppleSignIn.performRequests([
    AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  ]);

  switch (result.status) {
    case AuthorizationStatus.authorized:

    // Store user ID
      await FlutterSecureStorage()
          .write(key: "userId", value: result.credential.user);
      print('User complete');
      print(result.credential.email);
      print('User complete');
      print(result.credential.authorizationCode);
      print('User authorizationCode');
      print(result.credential.identityToken);
      print('User identityToken');
      print(result.credential.realUserStatus);
      print('User realUserStatus');
      print(result.credential.authorizedScopes);
      print('User authorizedScopes');
      print(result.credential.user);
      print('User user');
      print(result.credential.fullName.givenName);
      print('User givenName');
      print(result.credential.state);
      print('User state');



      break;

    case AuthorizationStatus.error:
      print("Sign in failed: ${result.error.localizedDescription}");

      break;

    case AuthorizationStatus.cancelled:
      print('User cancelled');
      break;
  }
}