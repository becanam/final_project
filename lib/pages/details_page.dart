import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midterm_project/utilities/detail_widget.dart';
import 'package:midterm_project/utilities/travel_options.dart';
import 'package:midterm_project/utilities/travelcards_list.dart';

class DetailsScreen extends ConsumerWidget {
  final TravelCard travelCard;

  const DetailsScreen({Key? key, required this.travelCard}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: DetailWidget(
              travelCard: travelCard, likes: "${ref.watch(counterProvider)}"),
        ),
      ),
    );
  }
}
