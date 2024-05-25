
import 'package:radvolontera_admin/models/school/school.dart';
import 'package:radvolontera_admin/providers/base_provider.dart';

class SchoolProvider extends BaseProvider<SchoolModel>{
 SchoolProvider(): super("School");
      
    @override
  SchoolModel fromJson(data) {
    // TODO: implement fromJson
    return SchoolModel.fromJson(data);
  } 
}