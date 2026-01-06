import 'package:petadopt_prueba2_app/features/adoption/domain/entities/adoption_request_entity.dart';

/// Estados para AdoptionCubit
abstract class AdoptionState {
  const AdoptionState();
}

/// Estado inicial
class AdoptionInitial extends AdoptionState {
  const AdoptionInitial();
}

/// Estado de carga
class AdoptionLoading extends AdoptionState {
  const AdoptionLoading();
}

/// Estado de solicitudes cargadas
class AdoptionRequestsLoaded extends AdoptionState {
  final List<AdoptionRequestEntity> requests;

  const AdoptionRequestsLoaded({required this.requests});
}

/// Estado de solicitud creada
class AdoptionRequestCreated extends AdoptionState {
  final AdoptionRequestEntity request;

  const AdoptionRequestCreated({required this.request});
}

/// Estado de solicitud actualizada
class AdoptionRequestUpdated extends AdoptionState {
  final AdoptionRequestEntity request;

  const AdoptionRequestUpdated({required this.request});
}

/// Estado de error
class AdoptionError extends AdoptionState {
  final String message;

  const AdoptionError({required this.message});
}
