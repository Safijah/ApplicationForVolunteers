

import 'package:radvolontera_admin/models/monitoring/monitoring.dart';
import 'package:radvolontera_admin/providers/base_provider.dart';

class MonitoringProvider extends BaseProvider<MonitoringModel>{
 MonitoringProvider(): super("Monitoring");
      
    @override
  MonitoringModel fromJson(data) {
    // TODO: implement fromJson
    return MonitoringModel.fromJson(data);
  } 
}