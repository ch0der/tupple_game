import 'package:flutter/material.dart';
import 'package:tupple_game/gameBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            onTap: () => onTileTapped(tile, index),
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


