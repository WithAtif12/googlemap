import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapproject/bottomnavigation.dart';
import 'package:googlemapproject/provider/delivery_provider.dart';
import 'package:googlemapproject/utils/colors.dart';
import 'package:googlemapproject/widgets/custom_button.dart';
import 'package:googlemapproject/widgets/order_on_the_way.dart';
import 'package:provider/provider.dart';

class DeliveryMapScreen extends StatefulWidget {
  const DeliveryMapScreen({super.key});

  @override
  State<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  GoogleMapController? _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Consumer<DeliveryProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                //google map
                _buildGoogleMap(provider),
    //order status widget layer - shows delivery progress and action buttons
                Consumer<DeliveryProvider>(
                    builder: (context, provider, child) {
                      if(provider.currentOrder == null) return SizedBox();
                        //show orderOnTheWay for all delivery status except rejected
             if(provider.status == DeliveryStatus.rejected)   {
               return SizedBox();
             }
                   return Align(
                     alignment: Alignment.bottomCenter,
                     child: Padding(padding: EdgeInsets.all(1),
                       child: OrderOnTheWay(
                           order: provider.currentOrder!,
                           status: provider.status,
                         onButtonPressed: (){
                             switch(provider.status) {
                               case DeliveryStatus.pickingUp:
                               provider.markAsPickedUp();
                               break;
                               case DeliveryStatus.destinationReached:
                                 provider.markAdDelivered();
                                 break;
                               case DeliveryStatus.markingAsDelivered:
                                 provider.completeDelivery();
                                 break;
                               default:
                                 break;
                             }
                         },
                       ),
                     ),

                   )   ;
                    }
                ),
                //delivery completed card
                if(provider.status == DeliveryStatus.delivered)
_buildDeliveryCompletedCard(provider),
          ],
            );
          }
      ),
    );
  }
//show success overlay when delivery is completed
  Widget _buildDeliveryCompletedCard(DeliveryProvider provider){
    return Positioned.fill(
        child: Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 100,width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/verified.png'),fit: BoxFit.cover),
                  ),
                  ),
              SizedBox(height: 16,),
              Text('Delivery Complete',style: TextStyle(
                fontSize: 20,fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 8,),
              Text('Great job! Your delivery has been successfully completed.',textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                fontSize: 14,
              ),),
              SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                child: CustomButton(title: 'Go Home',onPressed: (){
                  Navigator.of(context).pop();
                  provider.reseDelivery();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => NavigationMenu(),
                      ),
                      (route) => false,
                  );
                  },),
              )
            ],
          ),
        ),
      ),
    ));
  }
  Widget  _buildGoogleMap(DeliveryProvider provider) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        if(provider.currentOrder != null){
          _moveToLocation(provider.currentOrder!.pickupLocation);
        }
      },
        initialCameraPosition: CameraPosition(
            target: LatLng(27.7033, 85.3066),
          zoom: 14,
        ),
      markers: _buildMarkers(provider),
      polylines: _buildPolylines(provider),
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
    );
  }

  // creates map markers for pickup, delivery and delivery boy location
Set<Marker> _buildMarkers(DeliveryProvider provider) {
    Set<Marker> markers = {};

    if(provider.currentOrder != null){
      //pick marker
      markers.add(
        Marker(markerId: MarkerId(
          'Pickup',
        ),
          position: provider.currentOrder?.pickupLocation ?? LatLng(0.0, 0.0),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(title: 'Pickup location'),
        ),
      );
      //delivery marker
      markers.add(
        Marker(markerId: MarkerId(
          'delivery'),
          position: provider.currentOrder?.deliveryLocation ?? LatLng(0.0, 0.0),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(title: 'Delivery location'),
        ),
      );
      // delivery boy marker (when moving)
      if(provider.currentDeliveryBoyPosition != null){
        markers.add(
          Marker(markerId: MarkerId(
              'delivery_boy'),
            position: provider.currentDeliveryBoyPosition ?? LatLng(0.0, 0.0),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: InfoWindow(title: 'Delivery Boy'),
          ),
        );
        // move camera to follow delivery boy
        _moveToLocation(provider.currentDeliveryBoyPosition!);
      }
    }
    return markers;
}

//creates route line on map showing path between locations
  Set<Polyline> _buildPolylines(DeliveryProvider provider) {
    Set<Polyline> polylines = {};
    //show polyline when order is Accepted
    if(provider.routePoints.isNotEmpty && provider.status != DeliveryStatus.waitingForAcceptance && provider.status != DeliveryStatus.rejected){
      polylines.add(
        Polyline(polylineId: PolylineId('route'),
          points: provider.routePoints,
          color: buttonMainColor,
          width: 6,
        ),
      );
    }
    return polylines;
  }
// smothly moves map camera to specified location with animation according to the marker
void _moveToLocation(LatLng location) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 14));
}
}
