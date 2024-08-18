import 'package:bloc/bloc.dart';
import 'package:trip_list_filter/filter_enums.dart';
import 'package:trip_list_filter/trip.dart';
import 'package:trip_list_filter/trip_filters_view.dart';
part 'trip_filter_state.dart';

class TripFilterCubit extends Cubit<TripFilterState> {
  TripFilterCubit()
      : super(TripFilterState(
            filteredTrips: {},
            selectedBusOperators: {},
            selectedBusTypes: {},
            selectedShowOnlyFilter: null,
            selectedSortingFilter: null));

  _copywith(
      {Set<String>? selectedBusTypes,
      Set<String>? selectedBusOperators,
      Set<Trip>? filteredTrips,
      ShowOnlyFilter? selectedShowOnlyFilter,
      SortingFilter? selectedSortingFilter}) {
    return TripFilterState(
        selectedShowOnlyFilter:
            selectedShowOnlyFilter ?? state.selectedShowOnlyFilter,
        selectedSortingFilter:
            selectedSortingFilter ?? state.selectedSortingFilter,
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

  chooseSortingFilter(SortingFilter sortBy) {
    if (state.selectedSortingFilter == sortBy) {
      state.selectedSortingFilter = null;
      emit(_copywith(selectedSortingFilter: state.selectedSortingFilter));
    } else {
      emit(_copywith(selectedSortingFilter: sortBy));
    }
  }

  chooseShowOnlyFilter(ShowOnlyFilter showOnly) {
    if (state.selectedShowOnlyFilter == showOnly) {
      state.selectedShowOnlyFilter = null;
      emit(_copywith(selectedShowOnlyFilter: state.selectedShowOnlyFilter));
    } else {
      emit(_copywith(selectedShowOnlyFilter: showOnly));
    }
  }

  resetFilter(Set<Trip> trips) {
    state.selectedBusOperators.clear();
    state.selectedBusTypes.clear();
    state.selectedSortingFilter = null;
    state.selectedShowOnlyFilter = null;
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

    if (state.selectedShowOnlyFilter != null && filteredTrips.isNotEmpty) {
      switch (state.selectedShowOnlyFilter) {
        case ShowOnlyFilter.bargain:
          filteredTrips =
              filteredTrips.where((trip) => trip.canBargain).toSet();
          break;
        case ShowOnlyFilter.flashsales:
          filteredTrips =
              filteredTrips.where((trip) => trip.hasFlashsales).toSet();
        default:
      }
    }
    List<Trip> sortedList = [];
    if (state.selectedSortingFilter != null && filteredTrips.isNotEmpty) {
      sortedList = List.from(filteredTrips);
      switch (state.selectedSortingFilter) {
        case SortingFilter.lowrating:
          sortedList.sort((a, b) => a.rating.compareTo(b.rating));
          break;
        case SortingFilter.highrating:
          sortedList.sort((a, b) => a.rating.compareTo(b.rating));
          sortedList = List.from(sortedList.reversed);
          break;
        case SortingFilter.lowPrice:
          sortedList.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortingFilter.highPrice:
          sortedList.sort((a, b) => a.price.compareTo(b.price));
          sortedList = List.from(sortedList.reversed);
          break;
        default:
      }
    }
    emit(_copywith(
        filteredTrips:
            sortedList.isEmpty ? filteredTrips : sortedList.toSet()));
  }
}
