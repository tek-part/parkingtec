import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/features/vehicle/models/vehicle.dart';

// Vehicle State
class VehicleState {
  final bool isLoading;
  final List<Vehicle> vehicles;
  final List<Vehicle> requestedVehicles;
  final String? error;

  const VehicleState({
    this.isLoading = false,
    this.vehicles = const [],
    this.requestedVehicles = const [],
    this.error,
  });

  VehicleState copyWith({
    bool? isLoading,
    List<Vehicle>? vehicles,
    List<Vehicle>? requestedVehicles,
    String? error,
  }) {
    return VehicleState(
      isLoading: isLoading ?? this.isLoading,
      vehicles: vehicles ?? this.vehicles,
      requestedVehicles: requestedVehicles ?? this.requestedVehicles,
      error: error ?? this.error,
    );
  }
}

// Vehicle Notifier
class VehicleNotifier extends StateNotifier<VehicleState> {
  VehicleNotifier() : super(const VehicleState());

  Future<void> loadVehicles() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Load vehicles from API
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false, vehicles: []);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadRequestedVehicles() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Load requested vehicles from API
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false, requestedVehicles: []);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addVehicle({
    required String plate,
    required String model,
    required String color,
    required String lotId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Add vehicle via API
      await Future.delayed(const Duration(seconds: 1));

      final vehicle = Vehicle(
        id: DateTime.now().millisecondsSinceEpoch,
        customerName: '',
        carNum: plate,
        carModel: model,
        carColor: color,
        status: 'parked',
        lotId: int.tryParse(lotId),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      state = state.copyWith(
        isLoading: false,
        vehicles: [...state.vehicles, vehicle],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> completeVehicleRequest(String vehicleId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Complete vehicle request via API
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        isLoading: false,
        requestedVehicles: state.requestedVehicles
            .where((v) => v.id != int.parse(vehicleId))
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final vehicleNotifierProvider =
    StateNotifierProvider<VehicleNotifier, VehicleState>(
      (ref) => VehicleNotifier(),
    );

final vehiclesProvider = Provider<List<Vehicle>>((ref) {
  return ref.watch(vehicleNotifierProvider).vehicles;
});

final requestedVehiclesProvider = Provider<List<Vehicle>>((ref) {
  return ref.watch(vehicleNotifierProvider).requestedVehicles;
});

final vehicleLoadingProvider = Provider<bool>((ref) {
  return ref.watch(vehicleNotifierProvider).isLoading;
});

final vehicleErrorProvider = Provider<String?>((ref) {
  return ref.watch(vehicleNotifierProvider).error;
});
