import 'package:flutter/material.dart';
import 'package:tupple_game/gameBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math'as math;
import 'game_utils.dart';

class HologramTile extends StatelessWidget {
  final String letter;

  HologramTile({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.purple[100], // Giving it a distinct color
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.purple[700], // Give it a distinct text color too
        ),
      ),
    );
  }
}

class HologramRow extends StatelessWidget {
  final List<String> hologramLetters;

  HologramRow({required this.hologramLetters});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return HologramTile(letter: hologramLetters[index]);
      }),
    );
  }
}
class DestinationTilesRow extends StatelessWidget {
  final List<String> selectedLetters;
  final Function(int) onTileTapped;

  DestinationTilesRow({
    required this.selectedLetters,
    required this.onTileTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return GestureDetector(
          onTap: () => onTileTapped(index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: selectedLetters[index].isEmpty
                  ? BorderRadius.circular(8)
                  : BorderRadius.circular(12),
              border: Border.all(
                  color: selectedLetters[index].isEmpty
                      ? Colors.transparent
                      : Colors.green),
            ),
            alignment: Alignment.center,
            child: Text(
              selectedLetters[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        );
      }),
    );
  }
}
class SourceTilesRow extends StatelessWidget {
  final List<String> sourceLetters;
  final List<bool> isUsedList;
  final Function(GameTile, int) onTileTapped;

  SourceTilesRow({
    required this.sourceLetters,
    required this.isUsedList,
    required this.onTileTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
            (index) {
          GameTile tile = GameTile(
            letter: sourceLetters[index],
            placement: index,
            value: index + 1,
          );
          return TileWidget(
            isSelected: isUsedList[index],
            tile: tile,
            onTap: () {
              onTileTapped(tile, index);
              context.read<GameBloc>().add(LetterTappedInScrollerEvent(tile.letter));
            }
          );
        },
      ),
    );
  }
}
class GameTile {
  final String letter;
  final int placement;
  final int value;
  bool selected;
  bool isUsed;

  GameTile({
    required this.letter,
    required this.placement,
    required this.value,
    this.selected = false,
    this.isUsed = false,
  });
}

class TileWidget extends StatelessWidget {
  final GameTile tile;
  final VoidCallback onTap;
  final bool isSelected;

  TileWidget(
      {required this.tile, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    double _opacity = .25;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.grey.withOpacity(_opacity)
              : Colors.grey.withOpacity(.5),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          tile.letter,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color:
            isSelected ? Colors.black.withOpacity(_opacity) : Colors.black,
          ),
        ),
      ),
    );
  }
}
class AlphabetScroller extends StatefulWidget {
  final double _size =60;
  final List<String> alphabet;
  AlphabetScroller({Key? key, required this.alphabet}) : super(key: key);

  @override
  AlphabetScrollerState createState() => AlphabetScrollerState();
}

class AlphabetScrollerState extends State<AlphabetScroller> {
  late ScrollController _scrollController;
  final double _size =60;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void scrollToLetter(String letter) {
    final int index = widget.alphabet.indexOf(letter);
    _scrollController.animateTo(
      math.max(
          0.0,
          math.min(
              index * _size,
              _scrollController.position.maxScrollExtent
          )
      ),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );// Assuming each item has a width of 36 pixels, adjust accordingly.
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state){
        String? selectedLetter;
        if (state is LetterScrollerState) {
          selectedLetter = state.selectedLetter;
          scrollToLetter(state.selectedLetter);
        }
        return Container(
          height: _size,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),

            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.alphabet.length,
            itemBuilder: (context, index) {
              bool isSelected = widget.alphabet[index] == selectedLetter;
              return GestureDetector(
                onTap: () {
                  context.read<GameBloc>().add(LetterTappedInScrollerEvent(widget.alphabet[index]));
                },
                child: Container(
                  width: _size,
                  child: Center(
                    child: Text(
                      widget.alphabet[index],
                      style: TextStyle(fontSize: isSelected ? 30 : 20,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SolveRowLetters extends StatefulWidget {
  @override
  _SolveRowLettersState createState() => _SolveRowLettersState();
}

class _SolveRowLettersState extends State<SolveRowLetters> {
  late List<String> letters;

  @override
  void initState() {
    super.initState();
    letters = generateWeightedRandomLetters(6);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green,width: 2)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters.map((letter) => SolveLetterTile(letter)).toList(),
      ),
    );
  }
}


class SolveLetterTile extends StatelessWidget {
  final String letter;

  SolveLetterTile(this.letter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        letter,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

