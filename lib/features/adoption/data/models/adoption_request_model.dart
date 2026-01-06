import 'package:json_annotation/json_annotation.dart';

part 'adoption_request_model.g.dart';

/// Modelo de solicitud de adopción
@JsonSerializable()
class AdoptionRequestModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'pet_id')
  final String petId;

  @JsonKey(name: 'adopter_id')
  final String adopterId;

  @JsonKey(name: 'shelter_id')
  final String shelterId;

  @JsonKey(name: 'status')
  final String status; // 'pending', 'approved', 'rejected'

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  AdoptionRequestModel({
    required this.id,
    required this.petId,
    required this.adopterId,
    required this.shelterId,
    required this.status,
    this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$AdoptionRequestModelToJson(this);

  factory AdoptionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AdoptionRequestModelFromJson(json);

  AdoptionRequestModel copyWith({
    String? id,
    String? petId,
    String? adopterId,
    String? shelterId,
    String? status,
    String? message,
    String? createdAt,
    String? updatedAt,
  }) {
    return AdoptionRequestModel(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      adopterId: adopterId ?? this.adopterId,
      shelterId: shelterId ?? this.shelterId,
      status: status ?? this.status,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
