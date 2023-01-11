// class _EditProfileState extends State<EditProfile> {
//   ImagePicker picker = ImagePicker();
//   bool _isLoading = false;
//   String _error = '';
//   bool _pickImage = false;
//   String _permission = '';
//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//
// //get gallery permission
//   getGalleryPermission() async {
//     var status = await Permission.photos.status;
//     if (status != PermissionStatus.granted) {
//       status = await Permission.photos.request();
//     }
//     return status;
//   }
//
// //get camera permission
//   getCameraPermission() async {
//     var status = await Permission.camera.status;
//     if (status != PermissionStatus.granted) {
//       status = await Permission.camera.request();
//     }
//     return status;
//   }
//
// //pick image from gallery
//   pickImageFromGallery() async {
//     var permission = await getGalleryPermission();
//     if (permission == PermissionStatus.granted) {
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//       setState(() {
//         proImageFile = pickedFile?.path;
//         _pickImage = false;
//       });
//     } else {
//       setState(() {
//         _permission = 'noPhotos';
//       });
//     }
//   }
//
// //pick image from camera
//   pickImageFromCamera() async {
//     var permission = await getCameraPermission();
//     if (permission == PermissionStatus.granted) {
//       final pickedFile = await picker.pickImage(source: ImageSource.camera);
//       setState(() {
//         proImageFile = pickedFile?.path;
//         _pickImage = false;
//       });
//     } else {
//       setState(() {
//         _permission = 'noCamera';
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     _error = '';
//     proImageFile = null;
//     name.text = userDetails['name'];
//     email.text = userDetails['email'];
//     super.initState();
//   }
//
//   pop() {
//     Navigator.pop(context, true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Material(
//         child: Directionality(
//           textDirection: (languageDirection == 'rtl')
//               ? TextDirection.rtl
//               : TextDirection.ltr,
//           child: Stack(
//             children: [
//               Container(
//                 height: media.height * 1,
//                 width: media.width * 1,
//                 color: page,
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Stack(
//                             children: [
//                               Stack(
//                                 children: [
//                                   Container(
//                                     height: media.height * 0.1,
//                                     color: blueColor,
//                                     width: media.width * 1,
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       languages[choosenLanguage]
//                                       ['text_editprofile'],
//                                       style: GoogleFonts.roboto(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w600,
//                                           color: white),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: media.height * 0.03,
//                                     left: media.width * 0.03,
//                                     child: InkWell(
//                                       onTap: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: Icon(
//                                         Icons.arrow_back,
//                                         color: white,
//                                         size: media.height * 0.04,
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                       top: 0,
//                                       right: 0,
//                                       child: Image.asset(
//                                         height: media.height * 0.1,
//                                         'assets/images/app_bar_left_arrow.png',
//                                         fit: BoxFit.cover,
//                                       ))
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: media.width * 0.1),
//                           Container(
//                             height: 86,
//                             width: 86,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: page,
//                                 image: (proImageFile == null)
//                                     ? DecorationImage(
//                                     image: NetworkImage(
//                                       userDetails['profile_picture'],
//                                     ),
//                                     fit: BoxFit.cover)
//                                     : DecorationImage(
//                                     image: FileImage(File(proImageFile)),
//                                     fit: BoxFit.cover)),
//                           ),
//                           SizedBox(
//                             height: media.width * 0.04,
//                           ),
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 _pickImage = true;
//                               });
//                             },
//                             child: Text(
//                                 languages[choosenLanguage]['text_editimage'],
//                                 style: GoogleFonts.roboto(
//                                     fontSize: 16, color: blueColor)),
//                           ),
//                           SizedBox(
//                             height: media.width * 0.1,
//                           ),
//                           //edit name
//                           SizedBox(
//                               child: Align(alignment:Alignment.bottomLeft,
//                                 child: Padding(
//                                   padding:  EdgeInsets.only(left: media.width*0.12),
//                                   child: Text(
//                                     languages[choosenLanguage]['text_name'],
//                                     style: TextStyle(color: textColor, fontSize: 16),
//                                   ),
//                                 ),
//                               )),
//                           SizedBox(height: media.height*0.01,),
//                           SizedBox(
//                             width: media.width * 0.8,
//                             child: TextField(
//
//                               textDirection: (choosenLanguage == 'iw' ||
//                                   choosenLanguage == 'ur' ||
//                                   choosenLanguage == 'ar')
//                                   ? TextDirection.rtl
//                                   : TextDirection.ltr,
//                               controller: name,
//                               decoration: InputDecoration(
//
//                                   prefix: SizedBox(height: 18,width: 40,child: Image.asset('assets/images/text_fieldname_icon.png')),
//                                   border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(50),
//                                       gapPadding: 1),
//                                   isDense: true),
//                             ),
//                           ),
//                           SizedBox(
//                             height: media.width * 0.03,
//                           ),
//                           SizedBox(
//                               child: Align(alignment:Alignment.bottomLeft,
//                                 child: Padding(
//                                   padding:  EdgeInsets.only(left: media.width*0.12),
//                                   child: Text(
//                                     languages[choosenLanguage]['text_email'],
//                                     style: TextStyle(color: textColor, fontSize: 16),
//                                   ),
//                                 ),
//                               )),
//                           SizedBox(height: media.height*0.01,),
//                           SizedBox(
//                             width: media.width * 0.8,
//                             child: TextField(
//                               textDirection: (choosenLanguage == 'iw' ||
//                                   choosenLanguage == 'ur' ||
//                                   choosenLanguage == 'ar')
//                                   ? TextDirection.rtl
//                                   : TextDirection.ltr,
//                               controller: email,
//                               decoration: InputDecoration(
//                                   prefix: SizedBox(height: 18,width:40,child: Image.asset('assets/images/text_field_mail_icon.png')),
//                                   border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(50),
//                                       gapPadding: 1),
//                                   isDense: true),
//                             ),
//                           ),
//
//                           //edit email
//
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                         width: media.width * 0.8,
//                         child: Padding(
//                           padding:  EdgeInsets.only(bottom: media.height*0.03),
//                           child: Button(
//                               color:blueColor,
//                               height: media.height*0.07,
//                               onTap: () async {
//                                 setState(() {
//                                   _isLoading = true;
//                                 });
//                                 dynamic val;
//
//                                 if (proImageFile == null) {
//                                   val = await updateProfileWithoutImage(
//                                       name.text, email.text);
//                                 } else {
//                                   val =
//                                   await updateProfile(name.text, email.text);
//                                 }
//                                 if (val == 'success') {
//                                   pop();
//                                 } else {
//                                   setState(() {
//                                     _error = val.toString();
//                                   });
//                                 }
//                                 setState(() {
//                                   _isLoading = false;
//                                 });
//                               },
//                               text: languages[choosenLanguage]['text_confirm']),
//                         ))
//                   ],
//                 ),
//               ),
//
//               //pick image popup
//               (_pickImage == true)
//                   ? Positioned(
//                   bottom: 0,
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         _pickImage = false;
//                       });
//                     },
//                     child: Container(
//                       height: media.height * 1,
//                       width: media.width * 1,
//                       color: Colors.transparent.withOpacity(0.6),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(media.width * 0.05),
//                             width: media.width * 1,
//                             decoration: BoxDecoration(
//                                 borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(25),
//                                     topRight: Radius.circular(25)),
//                                 border: Border.all(
//                                   color: borderLines,
//                                   width: 1.2,
//                                 ),
//                                 color: page),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: media.width * 0.02,
//                                   width: media.width * 0.15,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(
//                                         media.width * 0.01),
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: media.width * 0.05,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Column(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             pickImageFromCamera();
//                                           },
//                                           child: Container(
//                                               height: media.width * 0.171,
//                                               width: media.width * 0.171,
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       color: borderLines,
//                                                       width: 1.2),
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                       12)),
//                                               child: Icon(
//                                                 Icons.camera_alt_outlined,
//                                                 size: media.width * 0.064,
//                                               )),
//                                         ),
//                                         SizedBox(
//                                           height: media.width * 0.01,
//                                         ),
//                                         Text(
//                                           languages[choosenLanguage]
//                                           ['text_camera'],
//                                           style: GoogleFonts.roboto(
//                                               fontSize: media.width * ten,
//                                               color:
//                                               const Color(0xff666666)),
//                                         )
//                                       ],
//                                     ),
//                                     Column(
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             pickImageFromGallery();
//                                           },
//                                           child: Container(
//                                               height: media.width * 0.171,
//                                               width: media.width * 0.171,
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       color: borderLines,
//                                                       width: 1.2),
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                       12)),
//                                               child: Icon(
//                                                 Icons.image_outlined,
//                                                 size: media.width * 0.064,
//                                               )),
//                                         ),
//                                         SizedBox(
//                                           height: media.width * 0.01,
//                                         ),
//                                         Text(
//                                           languages[choosenLanguage]
//                                           ['text_gallery'],
//                                           style: GoogleFonts.roboto(
//                                               fontSize: media.width * ten,
//                                               color:
//                                               const Color(0xff666666)),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ))
//                   : Container(),
//
//               //permission denied popup
//               (_permission != '')
//                   ? Positioned(
//                   child: Container(
//                     height: media.height * 1,
//                     width: media.width * 1,
//                     color: Colors.transparent.withOpacity(0.6),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: media.width * 0.9,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     _permission = '';
//                                     _pickImage = false;
//                                   });
//                                 },
//                                 child: Container(
//                                   height: media.width * 0.1,
//                                   width: media.width * 0.1,
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.circle, color: page),
//                                   child: const Icon(Icons.cancel_outlined),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: media.width * 0.05,
//                         ),
//                         Container(
//                           padding: EdgeInsets.all(media.width * 0.05),
//                           width: media.width * 0.9,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: page,
//                               boxShadow: [
//                                 BoxShadow(
//                                     blurRadius: 2.0,
//                                     spreadRadius: 2.0,
//                                     color: Colors.black.withOpacity(0.2))
//                               ]),
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                   width: media.width * 0.8,
//                                   child: Text(
//                                     (_permission == 'noPhotos')
//                                         ? languages[choosenLanguage]
//                                     ['text_open_photos_setting']
//                                         : languages[choosenLanguage]
//                                     ['text_open_camera_setting'],
//                                     style: GoogleFonts.roboto(
//                                         fontSize: media.width * sixteen,
//                                         color: textColor,
//                                         fontWeight: FontWeight.w600),
//                                   )),
//                               SizedBox(height: media.width * 0.05),
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   InkWell(
//                                       onTap: () async {
//                                         await openAppSettings();
//                                       },
//                                       child: Text(
//                                         languages[choosenLanguage]
//                                         ['text_open_settings'],
//                                         style: GoogleFonts.roboto(
//                                             fontSize: media.width * sixteen,
//                                             color: primaryColor,
//                                             fontWeight: FontWeight.w600),
//                                       )),
//                                   InkWell(
//                                       onTap: () async {
//                                         (_permission == 'noCamera')
//                                             ? pickImageFromCamera()
//                                             : pickImageFromGallery();
//                                         setState(() {
//                                           _permission = '';
//                                         });
//                                       },
//                                       child: Text(
//                                         languages[choosenLanguage]
//                                         ['text_done'],
//                                         style: GoogleFonts.roboto(
//                                             fontSize: media.width * sixteen,
//                                             color: primaryColor,
//                                             fontWeight: FontWeight.w600),
//                                       ))
//                                 ],
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ))
//                   : Container(),
//               //loader
//               (_isLoading == true)
//                   ? const Positioned(top: 0, child: Loading())
//                   : Container(),
//
//               //error
//               (_error != '')
//                   ? Positioned(
//                   child: Container(
//                     height: media.height * 1,
//                     width: media.width * 1,
//                     color: Colors.transparent.withOpacity(0.6),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(media.width * 0.05),
//                           width: media.width * 0.9,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: page),
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 width: media.width * 0.8,
//                                 child: Text(
//                                   _error.toString(),
//                                   textAlign: TextAlign.center,
//                                   style: GoogleFonts.roboto(
//                                       fontSize: media.width * sixteen,
//                                       color: textColor,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: media.width * 0.05,
//                               ),
//                               Button(
//                                   onTap: () async {
//                                     setState(() {
//                                       _error = '';
//                                     });
//                                   },
//                                   text: languages[choosenLanguage]['text_ok'])
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ))
//                   : Container(),
//
//               //no internet
//               (internet == false)
//                   ? Positioned(
//                   top: 0,
//                   child: NoInternet(
//                     onTap: () {
//                       setState(() {
//                         internetTrue();
//                       });
//                     },
//                   ))
//                   : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }