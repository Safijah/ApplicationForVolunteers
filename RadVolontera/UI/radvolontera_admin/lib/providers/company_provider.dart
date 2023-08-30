import 'package:radvolontera_admin/models/company/company.dart';

import 'base_provider.dart';

class CompanyProvider extends BaseProvider<CompanyModel>{
 CompanyProvider(): super("Company");
      
    @override
  CompanyModel fromJson(data) {
    // TODO: implement fromJson
    return CompanyModel.fromJson(data);
  } 
}