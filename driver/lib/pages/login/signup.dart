import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styles/styles.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.all(12.0),
    //       child: Column(
    //         children: [
    //           InkWell(
    //             onTap: () {
    //               Navigator.pop(context);
    //             },
    //             child: Row(
    //               children: [
    //                 Icon(Icons.arrow_back_ios),
    //                 Text('BACK', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),)
    //               ],
    //             ),
    //           ),
    //           SizedBox(height: 40,),
    //           Text('Let\'s Setup Your Account', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700)),
    //           SizedBox(height: 40,),
    //           MaterialApp(
    //             home: DefaultTabController(
    //               length: 3,
    //               child: Scaffold(
    //                 appBar: AppBar(
    //                   title: Text('Flutter Tabs Demo'),
    //                   bottom: TabBar(
    //                     tabs: [
    //                       Tab(text: "Personal Details"),
    //                       Tab(text: "Address"),
    //                       Tab(text: "Bank Details")
    //                     ],
    //                   ),
    //                 ),
    //                 body: TabBarView(
    //                   children: [
    //                     PersonalDetails(),
    //                     // SecondScreen(),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(150.0),
              child: AppBar(
                title: Text('Let\'s Setup Your Account', style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 24.0, color: black
                ),),
                centerTitle: true,
                backgroundColor: white,
                bottom: TabBar(
                  labelColor: primaryColor,
                  unselectedLabelColor: light_grey,
                  indicatorColor: primaryColor,
                  indicatorWeight: 4.0,
                  tabs: [
                    Tab(text: "Personal Detail"),
                    Tab(text: "Address"),
                    Tab(text: "Bank Details")
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                PersonalDetails(),
                PersonalDetails(),
                PersonalDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Full Name',
              icon: Icon(Icons.person_outline, color: light_grey,),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: primaryColor)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: light_grey)
              ),
            ),
          )
        ],
      ),
    );
  }
}
