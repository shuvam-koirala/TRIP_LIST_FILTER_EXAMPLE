import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_list_filter/trip_filter_cubit/trip_filter_cubit.dart';

class BusTypeWiseFilterView extends StatelessWidget {
  const BusTypeWiseFilterView({super.key, required this.busTypes});
  final Set<String> busTypes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bus Type",
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: -6,
            runAlignment: WrapAlignment.start,
            children: [
              ...busTypes.map((e) {
                return InkWell(
                  onTap: () {
                    context.read<TripFilterCubit>().chooseBusType(e);
                  },
                  child: BlocBuilder<TripFilterCubit, TripFilterState>(
                    builder: (context, state) {
                      return Chip(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: state.selectedBusTypes.contains(e)
                            ? Colors.blue
                            : Colors.white,
                        label: Text(
                          e.toUpperCase(),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class BusOperatorWiseFilterView extends StatelessWidget {
  const BusOperatorWiseFilterView({super.key, required this.busOperators});
  final Set<String> busOperators;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bus Operator",
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: -6,
            runAlignment: WrapAlignment.start,
            children: [
              ...busOperators.map((e) {
                return InkWell(
                  onTap: () {
                    context.read<TripFilterCubit>().chooseBusOperator(e);
                  },
                  child: BlocBuilder<TripFilterCubit, TripFilterState>(
                    builder: (context, state) {
                      return Chip(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: state.selectedBusOperators.contains(e)
                            ? Colors.blue
                            : Colors.white,
                        label: Text(
                          e.toUpperCase(),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          )
        ],
      ),
    );
  }
}
