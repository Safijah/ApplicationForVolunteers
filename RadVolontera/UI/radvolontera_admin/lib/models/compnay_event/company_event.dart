import 'package:json_annotation/json_annotation.dart';
import 'package:radvolontera_admin/models/company/company.dart';

part 'company_event.g.dart';

@JsonSerializable()
class CompanyEventModel {
  int? id;
  String? eventName;
  String location;
  String? time;
 int? companyId;
 CompanyModel? company;
 DateTime? eventDate;
 int price;
CompanyEventModel(this.id, this.eventName, this.location, this.time, this.company, this.companyId, this.eventDate,this.price);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory CompanyEventModel.fromJson(Map<String, dynamic> json) => _$CompanyEventModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CompanyEventModelToJson(this);
}
