library route.h_globals;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJOYW1lIjoiUm91dGVTdGF0aW9uIiwiUm9sZSI6InN1cGVyQWRtaW4iLCJleHAiOjE2NDYyOTE5NjQsImlzcyI6IkludmVudG9yeUF1dGhlbnRpY2F0aW9uU2VydmVyIiwiYXVkIjoiSW52ZW50b3J5U2VydmljZVBvdG1hbkNsaWVudCJ9._PExEnECldoA7gQASDsVl_f7_qGtRI_dRwxT-twhH-E";
final String baseURL = "https://route.click68.com";
final LatLng initialPoint = new LatLng(29.376291619820897, 47.98638395798397);

List packages = [
  {
    "id": "1",
    "name": "3 Month Pass",
    "duration/days": 90,
    "expiryDate": DateTime.now().add(365.days),
    "routes": "all",
    "price": 30.000,
    "company": "KPTC",
  },
  {
    "id": "2",
    "name": "Monthly Pass",
    "duration/days": 30,
    "expiryDate": DateTime.now().add(180.days),
    "routes": "all",
    "price": 12.500,
    "company": "KPTC",
  },
  {
    "id": "3",
    "name": "Weekly Pass",
    "duration/days": 7,
    "expiryDate": DateTime.now().add(90.days),
    "routes": "all",
    "price": 5.000,
    "company": "KPTC",
  },
  {
    "id": "4",
    "name": "Daily Pass",
    "duration/days": 1,
    "expiryDate": DateTime.now().add(60.days),
    "routes": "all",
    "price": 0.75,
    "company": "KPTC",
    "isActive":false
  },
  {
    "id": "1",
    "name": "3 Month Pass",
    "duration/days": 90,
    "expiryDate": DateTime.now().add(365.days),
    "routes": "all",
    "price": 30.000,
    "company": "KPTC",
  },
  {
    "id": "2",
    "name": "Monthly Pass",
    "duration/days": 30,
    "expiryDate": DateTime.now().add(180.days),
    "routes": "all",
    "price": 12.500,
    "company": "KPTC",
  },
  {
    "id": "3",
    "name": "Weekly Pass",
    "duration/days": 7,
    "expiryDate": DateTime.now().add(90.days),
    "routes": "all",
    "price": 5.000,
    "company": "KPTC",
  },
  {
    "id": "4",
    "name": "Daily Pass",
    "duration/days": 1,
    "expiryDate": DateTime.now().add(60.days),
    "routes": "all",
    "price": 0.75,
    "company": "KPTC",
    "isActive":false
  },
];
