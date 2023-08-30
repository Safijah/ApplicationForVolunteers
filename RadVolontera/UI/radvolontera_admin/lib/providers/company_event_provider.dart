import '../models/compnay_event/company_event.dart';
import 'base_provider.dart';

class CompanyEventProvider extends BaseProvider<CompanyEventModel>{
 CompanyEventProvider(): super("CompanyEvent");
      
    @override
  CompanyEventModel fromJson(data) {
    // TODO: implement fromJson
    return CompanyEventModel.fromJson(data);
  } 
}