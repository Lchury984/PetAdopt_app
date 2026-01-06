import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/adoption/domain/usecases/adoption_usecases.dart';
import 'package:petadopt_prueba2_app/features/adoption/presentation/cubit/adoption_state.dart';

/// Cubit para manejar solicitudes de adopción
class AdoptionCubit extends Cubit<AdoptionState> {
  final CreateAdoptionRequestUseCase createAdoptionRequestUseCase;
  final GetAdopterRequestsUseCase getAdopterRequestsUseCase;
  final GetShelterRequestsUseCase getShelterRequestsUseCase;
  final UpdateAdoptionRequestStatusUseCase updateAdoptionRequestStatusUseCase;

  AdoptionCubit({
    required this.createAdoptionRequestUseCase,
    required this.getAdopterRequestsUseCase,
    required this.getShelterRequestsUseCase,
    required this.updateAdoptionRequestStatusUseCase,
  }) : super(const AdoptionInitial());

  /// Crear nueva solicitud de adopción
  Future<void> createAdoptionRequest({
    required String petId,
    required String adopterId,
    required String shelterId,
    required String? message,
  }) async {
    emit(const AdoptionLoading());
    await createAdoptionRequestUseCase(
      petId: petId,
      adopterId: adopterId,
      shelterId: shelterId,
      message: message,
    ).then((request) {
      emit(AdoptionRequestCreated(request: request));
    }).catchError((error) {
      emit(AdoptionError(message: error.toString()));
    });
  }

  /// Obtener solicitudes del adoptante
  Future<void> getAdopterRequests(String adopterId) async {
    emit(const AdoptionLoading());
    await getAdopterRequestsUseCase(adopterId).then((requests) {
      emit(AdoptionRequestsLoaded(requests: requests));
    }).catchError((error) {
      emit(AdoptionError(message: error.toString()));
    });
  }

  /// Obtener solicitudes del refugio
  Future<void> getShelterRequests(String shelterId) async {
    emit(const AdoptionLoading());
    await getShelterRequestsUseCase(shelterId).then((requests) {
      emit(AdoptionRequestsLoaded(requests: requests));
    }).catchError((error) {
      emit(AdoptionError(message: error.toString()));
    });
  }

  /// Actualizar estado de solicitud
  Future<void> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    emit(const AdoptionLoading());
    await updateAdoptionRequestStatusUseCase(
      requestId: requestId,
      status: status,
    ).then((request) {
      emit(AdoptionRequestUpdated(request: request));
    }).catchError((error) {
      emit(AdoptionError(message: error.toString()));
    });
  }
}
