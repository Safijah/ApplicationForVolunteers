// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteering_announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolunteeringAnnouncementModel _$VolunteeringAnnouncementModelFromJson(
        Map<String, dynamic> json) =>
    VolunteeringAnnouncementModel(
      json['id'] as int?,
      json['place'] as String?,
      json['announcementStatusId'] as int?,
      json['announcementStatus'] == null
          ? null
          : StatusModel.fromJson(
              json['announcementStatus'] as Map<String, dynamic>),
      json['cityId'] as int?,
      json['city'] == null
          ? null
          : CityModel.fromJson(json['city'] as Map<String, dynamic>),
      json['mentorId'] as String?,
      json['mentor'] == null
          ? null
          : AccountModel.fromJson(json['mentor'] as Map<String, dynamic>),
      json['timeFrom'] as String,
      json['timeTo'] as String,
      json['reason'] as String?,
    )
      ..notes = json['notes'] as String?
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String);

Map<String, dynamic> _$VolunteeringAnnouncementModelToJson(
        VolunteeringAnnouncementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'place': instance.place,
      'announcementStatusId': instance.announcementStatusId,
      'announcementStatus': instance.announcementStatus,
      'cityId': instance.cityId,
      'city': instance.city,
      'mentorId': instance.mentorId,
      'mentor': instance.mentor,
      'timeFrom': instance.timeFrom,
      'timeTo': instance.timeTo,
      'notes': instance.notes,
      'date': instance.date?.toIso8601String(),
      'reason': instance.reason,
    };
