import 'package:json_annotation/json_annotation.dart';
import 'package:radvolontera_admin/models/city/city.dart';
import 'package:radvolontera_admin/models/company_category/company_category.dart';

part 'company.g.dart';

@JsonSerializable()
class CompanyModel {
  int? id;
  String? name;
  String? address;
  String? phoneNumber;
  String? email;
  int? cityId;
  CityModel? city;
  int ? companyCategoryId;
  CompanyCategoryModel? companyCategory;

CompanyModel(this.id, this.name,this.address,this.phoneNumber, this.email,this.cityId,this.city
,this.companyCategory, this.companyCategoryId);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory CompanyModel.fromJson(Map<String, dynamic> json) => _$CompanyModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}
