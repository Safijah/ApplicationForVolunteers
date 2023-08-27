import 'dart:ffi';


import 'package:json_annotation/json_annotation.dart';

import '../account/account.dart';

part 'payment.g.dart';

@JsonSerializable()
class PaymentModel {
  int? id;
  String? notes;
  double amount;
  int? month;
  String ? monthName;
  int? year;
  String? studentId;
  AccountModel? student;
 
 PaymentModel(this.id, this.notes, this.amount, this.month,this.year, this.studentId, this.student,this.monthName);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
