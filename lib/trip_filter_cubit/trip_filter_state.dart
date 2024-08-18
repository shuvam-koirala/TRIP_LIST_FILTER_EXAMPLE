part of "trip_filter_cubit.dart";

class TripFilterState {
  Set<String> selectedBusTypes = {};
  Set<String> selectedBusOperators = {};
  SortingFilter? selectedSortingFilter;
  ShowOnlyFilter? selectedShowOnlyFilter;
  Set<Trip> filteredTrips = {};
  TripFilterState(
      {required this.filteredTrips,
      required this.selectedBusOperators,
      required this.selectedBusTypes,
      required this.selectedShowOnlyFilter,
      required this.selectedSortingFilter});
}
