


import 'package:json_annotation/json_annotation.dart';
import 'package:radvolontera_mobile/models/account/account.dart';

part 'fit_pasos.g.dart';
@JsonSerializable()
class FITPasosModel {
  int? id;
 DateTime ? datumIzdavanja;
 bool isValid;
 String? userId;
AccountModel? user;
 
FITPasosModel(this.id, this.datumIzdavanja, this.isValid,this.user, this.userId);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
   factory FITPasosModel.fromJson(Map<String, dynamic> json) => _$FITPasosModelFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
   Map<String, dynamic> toJson() => _$FITPasosModelToJson(this);
}