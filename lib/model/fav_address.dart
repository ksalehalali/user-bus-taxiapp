import 'package:routes/model/location.dart';

class FavoriteAddress{
  final String id;
  final String name;
  final String address;
  final LocationModel location;
  final String createdDate;

  FavoriteAddress(this.name, this.address, this.location, this.createdDate,this.id);

}