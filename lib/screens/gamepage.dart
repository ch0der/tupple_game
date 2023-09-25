import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tupple_game/game_widgets.dart';
import 'package:tupple_game/game_utils.dart';
import 'package:tupple_game/gameBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupple_game/widgets/alphabet_scroll.dart';

class TestWordGame extends StatefulWidget {
  const TestWordGame({super.key});

  @override
  State<TestWordGame> createState() => _TestWordGameState();
}

class _TestWordGameState extends State<TestWordGame> {
  final ValueNotifier<String?> selectedLetterNotifier =
      ValueNotifier<String?>(null);

  List<String> selectedLetters = ["", "", "", "", "", ""];
  List<String> hologramLetters = ["", "", "", "", "", ""];
  List<String> sourceLetters = generateWeightedRandomLetters(6);
  List<bool> isUsedList = List.generate(6, (index) => false);

  void initState() {
    super.initState();
    context
        .read<GameBloc>()
        .add(LoadNewPuzzleEvent(generateWeightedRandomLetters(6)));
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameUpdatedState) {
          selectedLetters = state.selectedWords;
          hologramLetters = state.hologramWords;
          isUsedList = state.isTileUsedList;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Tupple Word Game"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(child: Container()),
                AlphabetScroll(
                  selectedLetterNotifier: selectedLetterNotifier,
                  onLetterSelected: (letter) {
                    print('Selected Letter: $letter');
                  },
                ),
                HologramRow(hologramLetters: hologramLetters),
                SizedBox(height: 10),
                DestinationTilesRow(
                  selectedLetters: selectedLetters,
                  onTileTapped: (index) {
                    context.read<GameBloc>().add(DeselectLetterEvent(index));
                  },
                ),
                SizedBox(height: 10),
                SourceTilesRow(
                  sourceLetters: sourceLetters,
                  isUsedList: isUsedList,
                  onTileTapped: (tile, index) {
                    context.read<GameBloc>().add(SelectWordEvent(tile.letter, index));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
