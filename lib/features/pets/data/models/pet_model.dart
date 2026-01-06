import 'package:json_annotation/json_annotation.dart';

part 'pet_model.g.dart';

/// Modelo de mascota para serialización JSON
@JsonSerializable()
class PetModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'type')
  final String type; // 'Perro', 'Gato', etc.

  @JsonKey(name: 'breed')
  final String breed;

  @JsonKey(name: 'age')
  final int age; // en meses

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @JsonKey(name: 'shelter_id')
  final String shelterId;

  @JsonKey(name: 'adopted')
  final bool adopted;

  @JsonKey(name: 'created_at')
  final String createdAt;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.description,
    this.imageUrl,
    required this.shelterId,
    this.adopted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => _$PetModelToJson(this);

  factory PetModel.fromJson(Map<String, dynamic> json) =>
      _$PetModelFromJson(json);

  PetModel copyWith({
    String? id,
    String? name,
    String? type,
    String? breed,
    int? age,
    String? description,
    String? imageUrl,
    String? shelterId,
    bool? adopted,
    String? createdAt,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      shelterId: shelterId ?? this.shelterId,
      adopted: adopted ?? this.adopted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
