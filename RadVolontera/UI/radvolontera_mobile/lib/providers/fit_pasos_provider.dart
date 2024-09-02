
import 'package:radvolontera_mobile/models/fit_pasos/fit_pasos.dart';

import 'base_provider.dart';

class FitPasosProvider extends BaseProvider<FITPasosModel>{
 FitPasosProvider(): super("FITPasos");
      
    @override
  FITPasosModel fromJson(data) {
    // TODO: implement fromJson
    return FITPasosModel.fromJson(data);
  } 
}