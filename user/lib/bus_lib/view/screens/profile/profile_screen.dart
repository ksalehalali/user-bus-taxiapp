import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../functions/functions.dart';
import '../../../Assistants/firebase_dynamic_link.dart';
import '../../../Assistants/globals.dart';
import '../../../Data/current_data.dart';
import '../../../controller/lang_controller.dart';
import '../../../controller/login_controller.dart';
import '../../../controller/packages_controller.dart';
import '../../../controller/personal_information_controller.dart';
import '../../../controller/sign_up_controller.dart';
import '../../../controller/start_up_controller.dart';
import '../../widgets/headerDesgin.dart';
import '../Auth/login.dart';
import '../packages/my_packages_screen.dart';
import '../packages/packages_screen.dart';
import 'favorite_addresses_screen.dart';
import 'help_screen.dart';
import 'personal_information.dart';
import 'your_activities_screen.dart';
import 'package:share_plus/share_plus.dart';


class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PersonalInformationController personalInfoController = Get.find();

  final StartUpController startUpController = Get.find();
  final LoginController loginController =  Get.find();

  final SignUpController signUpController= Get.find();

  showDialogBox() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title:  Text('Account delete_txt'.tr),
      content:  Text('Your account will be deleted_txt'.tr),
      actions: <Widget>[

        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Confirm_txt'.tr);
          },
          child:  Text('Close_txt'.tr),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Confirm_txt'.tr);
            personalInfoController.deleteMyAccount('id');
            loginController.logout();

            //notify the user account deleted
            CupertinoAlertDialog(
              title: const Text('Account deleted'),
              content: const Text('Your account deleted'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Ok');
                  },
                  child: const Text('Ok'),
                ),
              ],
            );


          },
          child:  Text('Confirm_txt'.tr),
        ),
      ],
    ),
  );


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [

          routes_color6,
          routes_color,
        ]
        )
      ),
      child: SafeArea(
        child: Scaffold(

            body: Stack(
              children: [
                Positioned(
                    top: 0.0,
                    width: screenSize.width,

                    child: SizedBox(
                        height: screenSize.height*0.1+11.h,
                        width: screenSize.width.w,
                        child: Header(screenSize))),
                Positioned(
                  top: 84 ,
                  child: SizedBox(
                    height: screenSize.height,
                    width: screenSize.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //
                            // Padding(
                            //     padding:
                            //     EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                            //     child: personalInfoController.profilePicture.value.path == "" ?
                            //     CircleAvatar(
                            //       radius: 40,
                            //       backgroundImage: NetworkImage(
                            //         'https://www.pngkey.com/png/full/349-3499617_person-placeholder-person-placeholder.png',
                            //       ),
                            //     ):
                            //     // display user profile picture.
                            //     CircleAvatar(
                            //       radius: 40,
                            //       backgroundImage: NetworkImage(
                            //           personalInfoController.profilePictureUrl.value//'https://www.pngkey.com/png/full/349-3499617_person-placeholder-person-placeholder.png',
                            //       ),
                            //     ),
                            // ),
                            SizedBox(
                              height: screenSize.height * 0.1 - 50.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    print(promoterId);
                                    Get.snackbar('Promoter Id', promoterId);
                      },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'your_account'.tr,
                                      style:TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.grey[800]),

                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(()=> PersonalInformation());
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person_pin,
                                          size: 32.sp,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 8.0.w,
                                        ),
                                        Text(
                                          'personal_info'.tr,
                                          style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[600]),

                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 22.sp,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //my fav addresses
                                SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: ()async {
                                     await  personalInfoController.myFavAddresses();
                                      Get.to(()=> FavoriteAddressesScreen());
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person_pin,
                                          size: 32.sp,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 8.0.w,
                                        ),
                                        Text(
                                          'yourFavoriteAddresses_txt'.tr,
                                          style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[600]),

                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 22.sp,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12.0.h,
                                ),

                                InkWell(
                                  onTap: (){
                                    Get.to(()=>YourActivitiesScreen());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                          size: 32.sp,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 8.0.w,
                                        ),
                                        Text(
                                          'your_activities'.tr,
                                          style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.grey[600]),

                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 22.sp,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                        SizedBox(
                        height: screenSize.height * 0.1 - 56.h,
                        ),
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Packages_txt'.tr,
                              style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.grey[800]),

                            ),
                          ),

                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 8.0.w,vertical: 12.h),
                            child: InkWell(
                              onTap: () {
                                Get.to(()=>PackagesScreen());

                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    size: 32.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8.0.w,
                                  ),
                                  Text(
                                    'Add Package_txt'.tr,
                                    style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.grey[600]),

                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 22.sp,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 8.0.w,vertical: 12.h),
                            child: InkWell(
                              onTap: () {

                                Get.to(()=>MyPackagesScreen());

                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.view_list,
                                    size: 32.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8.0.w,
                                  ),
                                  Text(
                                    'My Packages_txt'.tr,
                                    style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.grey[600]),

                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 22.sp,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'get_support_btn'.tr,
                              style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.grey[800]),

                            ),
                          ),

                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 8.0.w,vertical: 12.h),
                            child: InkWell(
                              onTap: () {
                                Get.to(()=> const HelpScreen());
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.help_center_outlined,
                                    size: 32.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8.0.w,
                                  ),
                                  Text(
                                    'help_btn'.tr,
                                    style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.grey[600]),

                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 22.sp,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),


                          // SizedBox(
                          //   height: 12,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: InkWell(
                          //     onTap: () {
                          //       Get.to(()=> const AboutUs());
                          //     },
                          //     child: Row(
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Icon(
                          //           Icons.help_center_outlined,
                          //           size: 32,
                          //           color: Colors.grey,
                          //         ),
                          //         SizedBox(
                          //           width: 8.0,
                          //         ),
                          //         Text(
                          //           'About Us',
                          //           style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.grey[600]),
                          //
                          //         ),
                          //         Spacer(),
                          //         Icon(
                          //           Icons.arrow_forward_ios_outlined,
                          //           size: 22,
                          //           color: Colors.grey,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 8.0.w,vertical: 12.h),
                            child: InkWell(
                              onTap: () {
                                Share.share('https://routesme.page.link/all', subject: 'share!');

                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.share_outlined,
                                    size: 32.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8.0.w,
                                  ),
                                  Text(
                                    'share_app_btn'.tr,
                                    style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.grey[600]),

                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 22.sp,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),



                          SizedBox(
                              height: screenSize.height * 0.1 - 58.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'setting_title'.tr,
                                    style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.grey[800]),

                                  ),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.language,
                                        size: 32.sp,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 8.0.w,
                                      ),
                                      Text(
                                        'btn_Lang'.tr,
                                        style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.grey[600]),

                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: 100.w,
                                        child: ListTile(

                                          leading: GetBuilder<LangController>(
                                            init: LangController(),
                                            builder: (controller)=> DropdownButton(
                                              iconSize: 38.sp,
                                              style: TextStyle(fontSize: 18.sp,color: Colors.blue[900],),
                                              items: const [
                                                DropdownMenuItem(child: Text('EN'),value: 'en',),
                                                DropdownMenuItem(child: Text('AR'),value: 'ar',),
                                               // DropdownMenuItem(child: Text('HI'),value: 'hi',)

                                              ],
                                              value:controller.appLocal ,
                                              onChanged: (val)async{
                                                print(val.toString());
                                                controller.changeLang(val.toString());
                                                Get.updateLocale(Locale(val.toString()));
                                                controller.changeDIR(val.toString());
                                                print(Get.deviceLocale);
                                                print(Get.locale);
                                                SharedPreferences prefs = await SharedPreferences.getInstance();

                                                await prefs.setString('lang', val.toString());
                                              },
                                            ),
                                          ),
                                          onTap: () {
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 8.0.w,vertical: 12.h),
                                  child: InkWell(
                                    onTap: () {
                                      showDialogBox();

                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete_forever_outlined,
                                          size: 32.sp,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 8.0.w,
                                        ),
                                        Text(
                                          'Remove account_txt'.tr,
                                          style:TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.grey[600]),

                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 22.sp,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2.h,
                                  width: screenSize.width - 20.w,
                                  color: Colors.grey[200],
                                ),
                                SizedBox(
                                  height: 22.0.h,
                                ),
                                Center(
                                    child: ElevatedButton.icon(
                                      icon: Icon(
                                        Icons.logout,
                                        size: 32.sp,
                                        color: Colors.red,
                                      ),
                                      onPressed: ()async {
                                       await loginController.logout();
                                       var result = await userLogout();
                                       if (result == 'success') {

                                           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
                                           userDetails.clear();
                                           userRequestData.clear();


                                       }

                                      },
                                      label: Text('btn_logOut'.tr,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                                      style: ElevatedButton.styleFrom(
                                          maximumSize: Size(Get.size.width -220.w,Get.size.width -220.w),
                                          minimumSize: Size(Get.size.width -220.w, 40.w),primary: Colors.white,
                                          onPrimary: routes_color,
                                          alignment: Alignment.center
                                      ),)
                                ),
                                const SizedBox(height: 22,),

                                Center(
                                  child: InkWell(
                                    onTap: ()async{
                                      // final genDynUrl=await FirebaseDynamicLinkService.createDynamicLink(false,'a1');
                                      // print(genDynUrl);
                                    },
                                    child:Text('terms_conditions_btn'.tr,style: TextStyle(fontSize: 15.sp,color: Colors.green[700]),),
                                  ),
                                ),

                                const Divider(),


                              ],
                            )
                          ],
                        ),
                            SizedBox(height:220.h)
                        ]),
                      )),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}