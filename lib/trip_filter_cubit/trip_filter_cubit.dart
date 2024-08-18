import 'package:bloc/bloc.dart';
import 'package:trip_list_filter/trip.dart';
part 'trip_filter_state.dart';

class TripFilterCubit extends Cubit<TripFilterState> {
  TripFilterCubit()
      : super(TripFilterState(
            filteredTrips: {}, selectedBusOperators: {}, selectedBusTypes: {}));

  _copywith(
      {Set<String>? selectedBusTypes,
      Set<String>? selectedBusOperators,
      Set<Trip>? filteredTrips}) {
    return TripFilterState(
        filteredTrips: filteredTrips ?? state.filteredTrips,
        selectedBusOperators:
            selectedBusOperators ?? state.selectedBusOperators,
        selectedBusTypes: selectedBusTypes ?? state.selectedBusTypes);
  }

  chooseBusOperator(String busOperator) {
    if (state.selectedBusOperators.contains(busOperator)) {
      state.selectedBusOperators.remove(busOperator);
      emit(_copywith(selectedBusOperators: state.selectedBusOperators));
    } else {
      state.selectedBusOperators.add(busOperator);
      emit(_copywith(selectedBusOperators: state.selectedBusOperators));
    }
  }

  chooseBusType(String busType) {
    if (state.selectedBusTypes.contains(busType)) {
      state.selectedBusTypes.remove(busType);
      emit(_copywith(selectedBusTypes: state.selectedBusTypes));
    } else {
      state.selectedBusTypes.add(busType);
      emit(_copywith(selectedBusTypes: state.selectedBusTypes));
    }
  }

  resetFilter(Set<Trip> trips) {
    state.selectedBusOperators.clear();
    state.selectedBusTypes.clear();
    applyFilter(trips);
  }

  applyFilter(Set<Trip> trips) {
    Set<Trip> filteredTrips = trips.where((trip) {
      bool matchesBusType = state.selectedBusTypes.isEmpty ||
          state.selectedBusTypes.contains(trip.busType);
      bool matchesBusOperator = state.selectedBusOperators.isEmpty ||
          state.selectedBusOperators.contains(trip.busOperator);
      return matchesBusType && matchesBusOperator;
    }).toSet();
    emit(_copywith(filteredTrips: filteredTrips));
  }
}
