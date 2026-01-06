// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adoption_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdoptionRequestModel _$AdoptionRequestModelFromJson(
        Map<String, dynamic> json) =>
    AdoptionRequestModel(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      adopterId: json['adopter_id'] as String,
      shelterId: json['shelter_id'] as String,
      status: json['status'] as String,
      message: json['message'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$AdoptionRequestModelToJson(
        AdoptionRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'adopter_id': instance.adopterId,
      'shelter_id': instance.shelterId,
      'status': instance.status,
      'message': instance.message,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
