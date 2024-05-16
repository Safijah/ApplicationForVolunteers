

import '../models/status/status.dart';
import 'base_provider.dart';

class StatusProvider extends BaseProvider<StatusModel>{
 StatusProvider(): super("Status");
      
    @override
  StatusModel fromJson(data) {
    // TODO: implement fromJson
    return StatusModel.fromJson(data);
  } 
}