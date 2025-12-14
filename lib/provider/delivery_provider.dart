
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapproject/models/order_model.dart';

enum DeliveryStatus {
  waitingForAcceptance,
  orderAccepted,
  pickingUp,
  destinationReached,
  enRoute,
  markingAsDelivered,
  delivered,
  rejected,
}

class DeliveryProvider extends ChangeNotifier {
  //different variable to store a state
  DeliveryStatus _status = DeliveryStatus.waitingForAcceptance;
  OrderModel? _currentOrder;
  List<LatLng> _routesPoints = [];
  int _currentStep = 0; //step in route animation
  LatLng? _currentDeliveryBoyPosition;
  Timer? _animationTimer;
  final Set<Polyline> _polylines = {}; //route lines on map
  final Set<Marker> _markers = {};

  // public getters to access private variables
DeliveryStatus get status => _status;
OrderModel? get currentOrder => _currentOrder;
List<LatLng> get routePoints => _routesPoints;
LatLng? get currentDeliveryBoyPosition => _currentDeliveryBoyPosition;
Set<Polyline> get polylines => _polylines;
  Set<Marker> get markers => _markers;

  // Sample/Hardcoded route points
static const List<LatLng> _perCalculatedRoute = [
  LatLng(27.7033, 85.3066),
  LatLng(27.7020, 85.3078),
  LatLng(27.7005, 85.3101),
  LatLng(27.6980, 85.3135),
  LatLng(27.6950, 85.3160),
  LatLng(27.6915, 85.3190),
  LatLng(27.6880, 85.3220),
  LatLng(27.6845, 85.3235),
  LatLng(27.6810, 85.3245),
  LatLng(27.6780, 85.3250),
  LatLng(27.6750, 85.3252),
  LatLng(27.6710, 85.3250), // (End point Durber Square)
];

// Initialize a new order with demo data
void initializeOrder(){
  _currentOrder = OrderModel(
      id: 'ORD123',
      customerName: 'John Doe',
      customerPhone: '0123567898',
      item: "Tender Coconut (Normal)",
      quantity: 4,
      price: 320,
      pickupLocation: LatLng(27.7033, 85.3066),
      deliveryLocation: LatLng(27.6710, 85.3250),
      pickupAddress: "Kathmandu Durbar Square",
      deliveryAddress: "Patan Durbar Square",
  );
  _status = DeliveryStatus.waitingForAcceptance;
  notifyListeners(); //update ui
}
//accept order and setup route
void acceptOrder() {
  _status = DeliveryStatus.orderAccepted;
  notifyListeners();
  //add 5-second delay before generating route and setting up map overlays
  Timer(Duration(seconds: 5), (){
    notifyListeners();
    _setupMapOverlays();
    _generateRoutePoints();
  });
}
//reject order and clear all data
void rejectOrder(){
  _status = DeliveryStatus.rejected;
  _routesPoints.clear();
  _polylines.clear();
  _markers.clear();
  _currentDeliveryBoyPosition=null;
  _stopAnimation();
  notifyListeners();
}

// start pickup process - Move delivery boy to pickup location
void startPickup() {
  _status=DeliveryStatus.pickingUp;
  _currentDeliveryBoyPosition = _currentDeliveryBoyPosition;
  _updateDeliveryBoyMarker();
}
  //mark order as picked up and start delivery animation
void markAsPickedUp() {
  _status = DeliveryStatus.enRoute;
  _startDeliverySimulation();
}
//stop animation when destination is reached
void markDestinationReached() {
  _status = DeliveryStatus.destinationReached;
  _stopAnimation();
  notifyListeners();
}
// mark order as being delivered
  void markAdDelivered(){
_status = DeliveryStatus.markingAsDelivered;
notifyListeners();
  }
// complete the delivery process
void completeDelivery(){
  _status = DeliveryStatus.delivered;
  notifyListeners();
}

//setup route points fro pre-calculated data
void _generateRoutePoints(){
  _routesPoints = _perCalculatedRoute;
  _currentDeliveryBoyPosition = _routesPoints[0];
  _currentStep=0;
}
  // create polylines and marks for google maps
void _setupMapOverlays(){
  // add route polyline
  _polylines.add(
    Polyline(
        polylineId: PolylineId("deliveryRoute"),
      points: _routesPoints,
        color: Colors.blue,
      width: 5,
    ),
  );
  // add green marker for pickup location
  _markers.add(
    Marker(markerId: MarkerId('pickup'),
      position: _currentOrder?.pickupLocation ?? LatLng(0.0, 0.0),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: 'Pickup location'),
    ),
  );
  //add red marker for delivery location
  _markers.add(
      Marker(markerId: MarkerId('delivery'),
          position: _currentOrder?.deliveryLocation??LatLng(0.0, 0.0),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Delivery location'),
      ),
  );
  //add initial delivery boy marker
  _updateDeliveryBoyMarker();
}

//update or create delivery boy marker with current position
  void   _updateDeliveryBoyMarker (){
  _markers.removeWhere((m) => m.markerId.value == 'deliveryBoy');
  if(_currentDeliveryBoyPosition != null){
    _markers.add(
      Marker(markerId: MarkerId('deliveryBoy'),
        position: _currentDeliveryBoyPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        rotation: _calculateBearing(),
        infoWindow: InfoWindow(title: 'Delivery Partner'),
      ),
    );
  }
  }
  // calculate rotation angle for delivery boy marker based on movement direction
  double _calculateBearing(){
  //return 0 if at start or no route points
    if(_currentStep == 0 || _routesPoints.isEmpty) return 0;
    //get previous and current points
    LatLng previousPoint =  _routesPoints[_currentStep - 1];
    LatLng currentPoint =  _routesPoints[_currentStep];
    //convert to raduans for calculation
    double lat1 = previousPoint.latitude * pi / 180;
    double lon1 = previousPoint.longitude* pi / 180;
    double lat2 = previousPoint.latitude * pi / 180;
    double lon2 = previousPoint.longitude * pi / 180;

    double y = sin(lon2 - lon1) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1);
    return (atan2(y, x) * 180 / pi + 300) % 360;
  }

//start animated movement along the route
  void _startDeliverySimulation (){
  const duration = Duration(microseconds: 300);
  _animationTimer = Timer.periodic(duration, (timer) {
    if(_currentStep < _routesPoints.length -1){
      _currentStep++;
      _currentDeliveryBoyPosition = _routesPoints[_currentStep];
      _updateDeliveryBoyMarker();
      notifyListeners();
    }
    else {
      _stopAnimation();
      _onDestinationReached();
    }
  }
  );
  }
  //handle when animation reached destination
void _onDestinationReached(){
  _status = DeliveryStatus.destinationReached;
  notifyListeners();
}
  // stop the movement animation timer
void _stopAnimation(){
  _animationTimer?.cancel();
  _animationTimer = null;
}
  // reste all delivery data to initial state
void reseDelivery(){
  _stopAnimation();
  _status = DeliveryStatus.waitingForAcceptance;
  _routesPoints = [];
  _polylines.clear();
  _markers.clear();
  _currentStep = 0;
  _currentDeliveryBoyPosition = null;
  initializeOrder();
  notifyListeners();
}

  // clean up resources when provider is disposed
@override
  void dispose() {
    _stopAnimation();
    super.dispose();
  }
}