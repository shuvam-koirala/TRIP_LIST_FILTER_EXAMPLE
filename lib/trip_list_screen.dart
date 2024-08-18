import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    Trip(0, "dhau0", "car", "abc"),
    Trip(1, "dhau1", "car", "def"),
    Trip(2, "dhau2", "car", "ghi"),
    Trip(3, "dhau3", "jeep", "abc"),
    Trip(4, "dhau4", "jeep", "def"),
    Trip(5, "dhau5", "jeep", "ghi"),
    Trip(6, "dhau6", "micro", "abc"),
    Trip(7, "dhau7", "micro", "def"),
    Trip(8, "dhau8", "micro", "ghi"),
  };

  Set<String> busTypes = {};
  Set<String> busOperators = {};

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
                      Text(trip.busName),
                      Text(trip.busOperator),
                      Text(trip.busType)
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
