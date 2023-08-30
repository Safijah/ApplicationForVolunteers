
import '../models/company_category/company_category.dart';
import 'base_provider.dart';

class CompanyCategoryProvider extends BaseProvider<CompanyCategoryModel>{
 CompanyCategoryProvider(): super("CompanyCategory");
      
    @override
  CompanyCategoryModel fromJson(data) {
    // TODO: implement fromJson
    return CompanyCategoryModel.fromJson(data);
  } 
}