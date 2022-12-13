import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/pages/vehicleInformations/vehicle_type.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';

import '../../functions/functions.dart';
import '../../translation/translation.dart';

class VehicleInfo extends StatefulWidget {
  const VehicleInfo({Key? key}) : super(key: key);

  @override
  State<VehicleInfo> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {

  String dropDownValue = '';

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: media.width * 0.08,
                  right: media.width * 0.08,
                  top: media.width * 0.05 + MediaQuery.of(context).padding.top),
              color: page,
              height: media.height * 1,
              width: media.width * 1,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.bottomLeft,
                      width: media.width * 1,
                      color: topBar,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back)),
                        ],
                      )),
                  SizedBox(
                    height: media.height * 0.03,
                  ),
                  Text('Vehicle Info', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28.0,),),
                  SizedBox(
                    height: media.height * 0.03,
                  ),
                  dropDownButtonFormField(),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  textField('Select Vehicle Make'),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  textField('Select Vehicle Model'),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  textField('Select Vehicle Year'),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  textField('Select Vehicle Number'),
                  SizedBox(
                    height: media.height * 0.02,
                  ),
                  textField('Select Vehicle Color'),
                  SizedBox(
                    height: media.height * 0.08,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2.5,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: notUploadedColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36.0)
                            )
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> VehicleType()));
                        },
                        child: Text('Next', style: TextStyle(fontSize: 18.0),)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField(hintText) {
    return Container(
      height: 50, width: MediaQuery.of(context).size.width,
      child: TextField(
        decoration: InputDecoration(
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.0),
                borderSide: BorderSide(color: primaryColor)
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.0),
                borderSide: BorderSide(color: light_grey)
            )
        ),
      ),
    );
  }

  Widget dropDownButtonFormField() {
    return Container(
      height: 58, width: MediaQuery.of(context).size.width,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          hintText: 'Select Vehicle Info',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: light_grey, width: 2),
            borderRadius: BorderRadius.circular(28.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(28.0),
          ),
        ),
        dropdownColor: Colors.greenAccent,
        value: dropDownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropDownValue = newValue!;
          });
        },
        items: <String>['Dog', 'Cat', 'Tiger', 'Lion'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
