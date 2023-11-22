

import 'package:json_annotation/json_annotation.dart';

part 'payment_report.g.dart';

@JsonSerializable()
class PaymentReportModel {
 double? amount;
 String? monthName;
 int? month;
 
 PaymentReportModel(this.monthName, this.amount, this.month);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PaymentReportModel.fromJson(Map<String, dynamic> json) => _$PaymentReportModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PaymentReportModelToJson(this);
}
