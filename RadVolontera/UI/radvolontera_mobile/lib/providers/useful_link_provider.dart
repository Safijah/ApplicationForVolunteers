

import '../models/useful_links/useful_link.dart';
import 'base_provider.dart';

class UsefulLinkProvider extends BaseProvider<UsefulLinkModel>{
 UsefulLinkProvider(): super("UsefulLinks");
      
    @override
  UsefulLinkModel fromJson(data) {
    // TODO: implement fromJson
    return UsefulLinkModel.fromJson(data);
  } 
}