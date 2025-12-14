import 'package:flutter/material.dart';
import 'package:googlemapproject/provider/delivery_provider.dart';
import 'package:googlemapproject/screen/delivery_map_screen.dart';
import 'package:googlemapproject/utils/colors.dart';
import 'package:googlemapproject/utils/route.dart';
import 'package:googlemapproject/utils/utils.dart';
import 'package:googlemapproject/widgets/custom_button.dart';
import 'dart:math';

import 'package:provider/provider.dart';
class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
        }, icon: Icon(Icons.arrow_back_ios,size: 20,)),
        title: Text('Order Details'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      // Customer information
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
     Padding(padding: EdgeInsets.only(left: 20,top: 12),
       child: Text(
           'Customer Information',
         style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 16,
           color: Colors.black,
         ),
       ),
     )    ,
     ListTile(
       leading: CircleAvatar(
         radius: 25,
         backgroundImage: AssetImage(
           'assets/1760452809208.jpeg',
         )
       ),
       title: Text("john Doe",style: TextStyle(
         fontWeight: FontWeight.bold,
       ),),
       subtitle: Text('Delivery * 0123467896'),
       trailing: CircleAvatar(
         backgroundColor: iconColor,
         child: Icon(Icons.phone,color: Colors.white,),
       ),
     )
          ],
        ),
      ),
              SizedBox(height: 12,),
              //Order summary
    Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 7,),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/tender cocunut.jpeg',
                    height: 50,width: 50,fit: BoxFit.cover,),
                  ),
                  SizedBox(width: 5,),
                  Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        children: [
           TextSpan(text: "Tender Cocunut (Normal) ") ,
           TextSpan(
             text: " * 4",
             style: TextStyle(color: Colors.black38),
           )
                        ]
                      )
                  )
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Row(
                    children: [
                     Icon(Icons.credit_card_outlined)       ,
                     SizedBox(width: 6,) ,
                     Text('Rs 320',style: TextStyle(
                             fontSize: 16,
                             color: iconColor,
                             fontWeight: FontWeight.w600,
                     ),)    ,
                    ],
                  ),
                  SizedBox(width: 10,),
                  Row(
                    children: [
                      Icon(Icons.verified,color: Colors.green,size: 20,)       ,
                      SizedBox(width: 6,) ,
                      Text('paid',style: TextStyle(
                        fontSize: 16,
                        color: iconColor,
                        fontWeight: FontWeight.w600,
                      ),)    ,
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
              SizedBox(height: 12,),
    //pickup and delivery
    Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(Icons.radio_button_checked,
                      color: Colors.black54,
                      size: 20,
                    ),
                    // dotted line
                    Container(
                      height: 90,
                      width: 2,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                            style: BorderStyle.solid,
                          )
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 14,),
                //PickUp + delivery Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    //pickup text
                    Text('Pickup Location',style: TextStyle(
                      fontSize: 16,fontWeight: FontWeight.w600,
                    ),) ,
                              SizedBox(height: 2)   ,
                      Text('West Patel Nagar\nIslamabad, 110088,Pakistan',style: TextStyle(
                        fontSize: 12,fontWeight: FontWeight.w400,
                      ),),
                      SizedBox(height: 2) ,
                      Text('Green Valley Cocunut * 0145667788',style: TextStyle(
                        fontSize: 9,color: Colors.grey,
                      ),) ,
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: iconColor,
                  child: Icon(Icons.phone,color: Colors.white,size: 18,),
                ),
                SizedBox(width: 20,),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.red.shade50,
                  child: Transform.rotate(angle: -pi/4,child: Icon(Icons.send,size: 18,color: buttonMainColor,
                  ),
                  ),
                ),
              ],
            ),
            // step 2 : delivery
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined,
                color: buttonMainColor,size: 22,),
                SizedBox(width: 12,),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Location',style: TextStyle(
                      fontSize: 16,fontWeight: FontWeight.w600,
                    ),) ,
                    SizedBox(height: 2,),
                    Text('West Patel Nagar\nIslamabad, 110088,Pakistan',style: TextStyle(
                      fontSize: 12,fontWeight: FontWeight.w400,
                    ),),
                    SizedBox(height: 2,),
                    Text('John Doe',style: TextStyle(
                      fontSize: 12,color: Colors.grey,
                    ),) ,
                  ],),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.red.shade50,
                  child: Transform.rotate(angle: -pi/4,child: Icon(Icons.send,size: 18,color: buttonMainColor,),),
                )
              ],
            )
          ],
        ),
      ),
    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<DeliveryProvider>(
          builder: (context, provider, child) {
            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                child: provider.status == DeliveryStatus.orderAccepted
                ? CustomButton(title: 'Start Pickup',onPressed: (){
                  //move delivery bag to pickup location and navigate to map
                  context.read<DeliveryProvider>().startPickup();
                  NavigationHelper.pushReplacement(context, DeliveryMapScreen());
                },
                )
                :
                Row(
                  children: [
            Expanded(
              child: CustomButton(
              color: declineOrder,
                textColor: Colors.black54,
                title: 'Decline Order',
              onPressed: (){
                context.read<DeliveryProvider>().rejectOrder();
                Navigator.pop(context);
                showAppSnackbar(
                    context: context,
                    type: SnackbarType.error,
                    description:"Order is not accepted",
                );
              },
            ),
            )    ,
            SizedBox(width: 10,)       ,
                    Expanded(
                      child: CustomButton(
                        title: 'Accept Order',
                        onPressed: (){
                          context.read<DeliveryProvider>().acceptOrder();
                        },
                      ),
                    )    ,
                  ],
                ),
              ),
            );
          }
      )
    );
  }
}
