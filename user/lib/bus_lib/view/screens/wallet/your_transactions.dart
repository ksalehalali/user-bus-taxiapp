
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/payment_controller.dart';
import '../../widgets/dialogs.dart';

class YourTransactionsScreen extends StatefulWidget {
  const YourTransactionsScreen({Key? key}) : super(key: key);

  @override
  _YourTransactionsScreenState createState() => _YourTransactionsScreenState();
}

class _YourTransactionsScreenState extends State<YourTransactionsScreen> {
  final PaymentController walletController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final screenSize =MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: InkWell(
          onTap: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back,color: Colors.blue[900],size: 32,),
        ),
        title: Text('your_transactions_txt'.tr,style: TextStyle(color: Colors.blue[900]),),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('history_txt'.tr,style: TextStyle(color: Colors.blue[900],fontSize: 16,fontWeight: FontWeight.bold),),
                    ),
               Spacer(),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Obx(()=>Text('${walletController.totalOfMyPayments.value}',style: TextStyle(color: Colors.blue[900],fontSize: 16,fontWeight: FontWeight.bold),)),
               ),
             ],
           ),
            SizedBox(
              height: screenSize.height -140,
              child: FutureBuilder(
                  future: walletController.getMyListOfPayments(),
                  builder: (context,data)=> Obx(()=> ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: walletController.payments.length,
                      itemBuilder: (context,index)=>Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('route ${walletController.payments[index].routeName.toString()}',style: TextStyle(color: Colors.black),),
                                    subtitle:  Text(DateFormat('yyyy-MM-dd  HH:mm :ss').format(DateTime.parse(walletController.payments[index].date!)),style: TextStyle(height: 2),),
                                    trailing:  Text(walletController.payments[index].value!.toStringAsFixed(3),style: TextStyle(color:Colors.red,fontWeight: FontWeight.w600),),
                                    onTap: (){
                                      showDialog(context: context, builder: (context)=>CustomDialog(payment:  walletController.payments[index],fromPaymentLists: false,failedPay: false,));
                                    },
                                  ),
                                  Divider(thickness: 1,height: 10,)
                                ],
                              )
                            ),
                          ],
                        ),
                      ))
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
