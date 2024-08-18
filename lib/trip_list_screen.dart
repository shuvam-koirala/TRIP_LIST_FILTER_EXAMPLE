import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_list_filter/filter_enums.dart';
import 'package:trip_list_filter/trip.dart';
import 'package:trip_list_filter/trip_filter_cubit/trip_filter_cubit.dart';
import 'package:trip_list_filter/trip_filters_view.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  final Set<Trip> trips = {
    Trip(0, "dhau0", "car", "abc", 2, 1200,
        canBargain: true, hasFlashsales: true),
    Trip(1, "dhau1", "car", "def", 4, 1150,
        canBargain: false, hasFlashsales: true),
    Trip(2, "dhau2", "car", "ghi", 1, 1350,
        canBargain: false, hasFlashsales: true),
    Trip(3, "dhau3", "jeep", "abc", 3, 800,
        canBargain: true, hasFlashsales: true),
    Trip(4, "dhau4", "jeep", "def", 5, 860,
        canBargain: true, hasFlashsales: true),
    Trip(5, "dhau5", "jeep", "ghi", 2, 1260.50,
        canBargain: false, hasFlashsales: false),
    Trip(6, "dhau6", "micro", "abc", 1, 1160,
        canBargain: false, hasFlashsales: false),
    Trip(7, "dhau7", "micro", "def", 3, 900,
        canBargain: false, hasFlashsales: true),
    Trip(8, "dhau8", "micro", "ghi", 4, 1000,
        canBargain: false, hasFlashsales: true),
  };

  Set<String> busTypes = {};
  Set<String> busOperators = {};
  Set<SortingFilter> sortingFilters = {
    SortingFilter.highrating,
    SortingFilter.lowrating,
    SortingFilter.lowPrice,
    SortingFilter.highPrice
  };
  Set<ShowOnlyFilter> showOnlyFilters = {
    ShowOnlyFilter.bargain,
    ShowOnlyFilter.flashsales
  };
  @override
  void initState() {
    fetchFilterValues();
    context.read<TripFilterCubit>().applyFilter(trips);
    super.initState();
  }

  fetchFilterValues() {
    busOperators.clear();
    busTypes.clear();
    for (Trip trip in trips) {
      if (!busOperators.contains(trip.busOperator)) {
        busOperators.add(trip.busOperator);
      }
      if (!busTypes.contains(trip.busType)) {
        busTypes.add(trip.busType);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    useSafeArea: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<TripFilterCubit>()
                                          .resetFilter(trips);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "RESET",
                                    ),
                                  ),
                                  Text(
                                    "Filter",
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<TripFilterCubit>()
                                          .applyFilter(trips);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "DONE",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BusTypeWiseFilterView(busTypes: busTypes),
                                    BusOperatorWiseFilterView(
                                      busOperators: busOperators,
                                    ),
                                    SortingFilterView(
                                      sortingFilters: sortingFilters,
                                    ),
                                    ShowOnlyFilterView(
                                      showOnlyFilters: showOnlyFilters,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.filter_alt))
        ],
        centerTitle: true,
        title: const Text("Trip List"),
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<TripFilterCubit, TripFilterState>(
        builder: (context, state) {
          return ListView.separated(
              itemBuilder: (context, index) {
                final Trip trip = state.filteredTrips.elementAt(index);
                return Card(
                  child: Column(
                    children: [
                      Text("Price :- Rs. ${trip.price}"),
                      Text("Bus Name:- ${trip.busName}"),
                      Text("Operator:- ${trip.busOperator}"),
                      Text("Bus Type:- ${trip.busType}"),
                      Text("Rating:- ${trip.rating} star"),
                      trip.canBargain
                          ? Text("Bargainable trip")
                          : SizedBox.shrink(),
                      trip.hasFlashsales
                          ? Text("Has Flassales")
                          : SizedBox.shrink(),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemCount: state.filteredTrips.length);
        },
      ),
    );
  }
}
