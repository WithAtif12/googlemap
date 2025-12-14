import 'package:flutter/material.dart';
import 'package:googlemapproject/screen/order_detail_screen.dart';
import 'package:googlemapproject/utils/colors.dart';
import 'package:googlemapproject/utils/route.dart';
import 'package:googlemapproject/widgets/custom_button.dart';
import 'package:googlemapproject/widgets/dash_vertical_line.dart';
import 'package:googlemapproject/widgets/pickUpandDeliveryInfo.dart';
class OrderCard extends StatelessWidget {
  String tenderCoconut = "https://your-image-url.com/image.png";
   OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
           mainAxisSize: MainAxisSize.min,
          children: [
            // order details
            Row(
              children: [
                Text('New Order Available',style: TextStyle(
                  fontSize: 18,fontWeight: FontWeight.w800,
                ),)    ,
                SizedBox(width: 15,),
                Text('Rs320',style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: buttonMainColor,
                ),),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 6,),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              elevation: 1,
              shadowColor: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.only(left: 5,top: 3,bottom: 3),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage('assets/tender cocunut.jpeg'),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                        SizedBox(width: 6,),
                        Text.rich(
                            TextSpan(
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(text: 'Tender Coconut (Normal)'),
                                  TextSpan(
                                    text: " *4",
                                    style: TextStyle(color: Colors.black38,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12,),
            //pickup and delivery locations
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // step 1 : Pickup
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.radio_button_checked,
                            color: Colors.black54,
                            size: 20,
                          ),
                          SizedBox(
                            height: 40,
                            child: DashVerticalLine(
                              dashHeight: 5,
                              dashGap: 5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12,),
                      PickupAndDeliveryInfo(
                        title: "Pickup -",
                        address: "kathmandu square - 1.2 km from you",
                        subtitle: "Green Valley Coconut Store",
                      ),

                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: buttonMainColor,
                        size: 22,
                      ),
                      SizedBox(width: 5,),
                      PickupAndDeliveryInfo(
                        title: "Delivery -",
                        address: "Mandogo square - 1.3 km from you",
                        subtitle: "John Doe",
                      ),
                    ],
                  ),
                ],
              ),
            /// steps 2: Delivery
            SizedBox(height: 15,),
            //action button
            SizedBox(
              width: double.maxFinite,
              child: CustomButton(
                title: 'View Order details',
                onPressed: (){
                  NavigationHelper.push(context, OrderDetailScreen());
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}

