import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midterm_project/utilities/animation.dart';
import 'package:midterm_project/utilities/travelcards_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'travel_options.g.dart';

@riverpod
class Counter extends _$Counter {
  /// Classes annotated by `@riverpod` **must** define a [build] function.
  /// This function is expected to return the initial state of your shared state.
  /// It is totally acceptable for this function to return a [Future] or [Stream] if you need to.
  /// You can also freely define parameters on this method.
  @override
  int build() => 0;

  void increment() => state++;
  void decrease() => state--;
}

class PlacesToTravel extends ConsumerWidget {
  final TravelCard travelCard;
  final VoidCallback? onTap;
  const PlacesToTravel({Key? key, required this.travelCard, this.onTap})
      : super(key: key);

  @override
  Widget build(
    BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: const Alignment(0, 1.25),
                    children: <Widget>[
                      //city image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100),
                        ),
                        child: Image.asset(travelCard.cityImage,
                            height: 240, fit: BoxFit.cover),
                      ),

                      //country flag
                      Align(
                        child: Image.asset(
                          travelCard.flag,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 33,
                  ),

                  //country name
                  Text(
                    travelCard.cityName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  //rating
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              travelCard.rating,
                              style: const TextStyle(
                                  height: 2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(
                                  travelCard.icon,
                                  color: travelCard.iconColor,
                                ),
                                onPressed: () => ref.read(counterProvider.notifier).increment() 
                              ),
                              Text('${ref.watch(counterProvider)}'),
                              IconButton(
                                            icon: const Icon(Icons.thumb_up, size: 25,),
                                            color: const Color.fromARGB(255,
                                                158, 158, 158), // Default color
                                            onPressed: () {
                                              // Trigger the exploding animation
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: ExplodingThumbsUp(),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}
