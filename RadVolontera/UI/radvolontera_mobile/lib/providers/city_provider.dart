
import 'package:radvolontera_mobile/models/city/city.dart';

import 'base_provider.dart';

class CityProvider extends BaseProvider<CityModel>{
 CityProvider(): super("City");
      
    @override
  CityModel fromJson(data) {
    // TODO: implement fromJson
    return CityModel.fromJson(data);
  } 
}