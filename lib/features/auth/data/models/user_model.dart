import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Modelo de usuario para serialización JSON (data layer)
@JsonSerializable()
class UserModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'full_name')
  final String fullName;

  @JsonKey(name: 'role')
  final String role;

  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'latitude')
  final double? latitude;

  @JsonKey(name: 'longitude')
  final double? longitude;

  @JsonKey(name: 'created_at')
  final String createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.profileImageUrl,
    this.phone,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  /// Convertir modelo a JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Crear modelo desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Copiar con cambios
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? role,
    String? profileImageUrl,
    String? phone,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
