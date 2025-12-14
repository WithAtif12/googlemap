
import 'package:geolocator/geolocator.dart';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// For mobile current GPS location
class CurrentLocationProvider extends ChangeNotifier {

//private data
   LatLng _currentLocation = LatLng(37.7749,122.4194);
   bool _isLoading = true;
   String _errorMessage = '';

   //public getters to access private variables
LatLng get currentLocation => _currentLocation;
bool get isLoading => _isLoading;
String get errorMessage => _errorMessage;

CurrentLocationProvider (){
  _getCurrentLocation();
}

//main function to get device current location
 Future<void>  _getCurrentLocation() async{
  try{
    //check if location permission is granted
    LocationPermission permission = await Geolocator.checkPermission();
    //request permission if denied
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied) {
        _errorMessage = "Location permission denied. Use default location.";
        _isLoading = false;
        notifyListeners();
        return;
      }
    }
    //Gps service check
    //check if location service are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      _errorMessage = "Location service are disable";
      _isLoading = false;
      notifyListeners();
      return;
    }


    //get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );



    //success - update location and clear loading/error states.
    //phone se exact latitude & longitude
    _currentLocation = LatLng(position.latitude, position.longitude);
    //Success state
    _isLoading = false;
    _errorMessage = "";
    notifyListeners();
  }  catch(e) {
    //handle any error during location retrieval
    //app not crash default location show how ga
    _errorMessage = "Error getting location ${e.toString()}. Use default location.";
    _isLoading=false;
    notifyListeners();
  }
 }

 //public method to manually refresh location (can by called by UI)
void refreshLocation(){
  _isLoading= true;
  _errorMessage = '';
  notifyListeners();
  _getCurrentLocation();
}
}