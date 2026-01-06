// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetModel _$PetModelFromJson(Map<String, dynamic> json) => PetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      breed: json['breed'] as String,
      age: (json['age'] as num).toInt(),
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      shelterId: json['shelter_id'] as String,
      adopted: json['adopted'] as bool? ?? false,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$PetModelToJson(PetModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'breed': instance.breed,
      'age': instance.age,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'shelter_id': instance.shelterId,
      'adopted': instance.adopted,
      'created_at': instance.createdAt,
    };
