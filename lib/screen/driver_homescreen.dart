import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapproject/provider/current_location_provider.dart';
import 'package:googlemapproject/provider/delivery_provider.dart';
import 'package:googlemapproject/utils/utils.dart';
import 'package:googlemapproject/widgets/order_card.dart';
import 'package:provider/provider.dart';
class DriverHomescreen extends StatefulWidget {
  const DriverHomescreen({super.key});

  @override
  State<DriverHomescreen> createState() => _DriverHomescreenState();
}

class _DriverHomescreenState extends State<DriverHomescreen> {
  GoogleMapController? mapController;
  bool isOnline = true;

  @override
  void initState() {
    // TODO: implement initState
    Future.microtask(() {
      context.read<DeliveryProvider>().initializeOrder();
    });
    super.initState();
  }
  // callback when google map is ready
  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }

  //create marker for current location on map
  Set<Marker> _buildMarkers(LatLng currentLocation){
    return {
      Marker(markerId: MarkerId("current_location"),
        position: currentLocation,
        infoWindow: InfoWindow(
          title: 'Current Location',
          snippet: "you are here!",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<CurrentLocationProvider>(
          builder:(context, locationProvider, child) {
            //show loading spinner while getting location
        if(locationProvider.isLoading){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
  CircularProgressIndicator(),
  SizedBox(height: 15,),
  Text('Getting your location...'),
              ],
            ),
          );
        }

 // show the error message after permission denied
   if(locationProvider.errorMessage.isNotEmpty){
     WidgetsBinding.instance.addPostFrameCallback((_){
       showAppSnackbar(
           context: context,
           type: SnackbarType.error,
           description:locationProvider.errorMessage,
       );
     });
   }
   Size size = MediaQuery.of(context).size;
   return Stack(
     children: [
       // display the google map
       GoogleMap(
         onMapCreated: _onMapCreated,
           markers: _buildMarkers(locationProvider.currentLocation),
           initialCameraPosition: CameraPosition(
               target: locationProvider.currentLocation,
             zoom: 15,
           ),
         myLocationEnabled: true,
         myLocationButtonEnabled: false,
         mapType: MapType.normal,
       ),
         if(locationProvider.errorMessage.isEmpty)
         // show order car at bottom
         Align(
           alignment: Alignment.bottomCenter,
           child: Padding(
               padding: EdgeInsets.all(15),
             child: OrderCard(),
           ),
         ),
         //show static online button at the top
         Align(
           alignment: Alignment.topCenter,
           child: Container(
             height: size.height * 0.12,
             color: Colors.white,
             child: Padding(
                 padding: EdgeInsets.only(bottom: 8),
               child: Center(
                 child: Align(
                   alignment: Alignment.bottomCenter,
                   child: Container(
                       height: 38,
                     width: 200,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(30),
                       border: Border.all(color: Colors.red,width: 2),
                     ),
                     child: Padding(
                         padding: EdgeInsets.all(2.0),
                       child: Row(
                         children: [
                           //Online button
                      Expanded(
                        flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Text('Online',style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),),
                          )
                      ),
                           Expanded(child: SizedBox(),),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             ),
           ),
         ),

     ],
   );
          }
      )

    );
  }
}
