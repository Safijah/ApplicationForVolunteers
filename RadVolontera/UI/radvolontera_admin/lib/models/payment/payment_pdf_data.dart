import 'package:json_annotation/json_annotation.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/models/payment/payment.dart';

part 'payment_pdf_data.g.dart';

@JsonSerializable()
class PaymentPdfDataModel {
List<PaymentModel> payments;
 AccountModel? student;
 
 PaymentPdfDataModel(this.student, this.payments);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PaymentPdfDataModel.fromJson(Map<String, dynamic> json) => _$PaymentPdfDataModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PaymentPdfDataModelToJson(this);
}
