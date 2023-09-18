import 'package:flutter/material.dart';
import 'dart:math';

class TestWordGame extends StatefulWidget {
  const TestWordGame({super.key});

  @override
  State<TestWordGame> createState() => _TestWordGameState();
}

class _TestWordGameState extends State<TestWordGame> {

  List<String> selectedLetters = ["", "", "", "", "", ""];
  List<String> sourceLetters = generateWeightedRandomLetters(6);


  void deselectLetter(int index) {
    setState(() {
      selectedLetters[index] = "";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tupple Word Game"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Destination Tiles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return GestureDetector(
                  onTap: () {
                    deselectLetter(index);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: selectedLetters[index].isEmpty ? Colors.grey[300] : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black54, width: 1),
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
            ),
            SizedBox(height: 20),
            // Source Tiles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                GameTile tile = GameTile(letter:sourceLetters[index],placement: index, value: index+1);

                return TileWidget(
                  tile: tile,
                  onTap: () {
                    print("Tile ${tile.letter} tapped!");
                    setState(() {
                      for (int i = 0; i < selectedLetters.length; i++) {
                        if (selectedLetters[i] == "") {
                          selectedLetters[i] = tile.letter;
                          break;
                        }
                      }
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class GameTile {
  final String letter;
  final int placement;
  final int value;
  bool selected;

  GameTile({
    required this.letter,
    required this.placement,
    required this.value,
    this.selected = false,
  });
}

class TileWidget extends StatefulWidget {
  final GameTile tile;
  final VoidCallback onTap;

  TileWidget({required this.tile, required this.onTap});

  @override
  _TileWidgetState createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.tile.selected = !widget.tile.selected;
        });
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: widget.tile.selected ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black54, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.tile.letter,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}

List<String> generateWeightedRandomLetters(int count) {
  final allLetters = [
    'E', 'T', 'A', 'O', 'I', 'N', 'S', 'H', 'R', 'D', 'L', 'C', 'U', 'M', 'W',
    'F', 'G', 'Y', 'P', 'B', 'V', 'K', 'J', 'X', 'Q', 'Z'
  ];

  final weights = [
    13, 9, 8, 8, 7, 7, 6, 6, 6, 4, 4, 3, 3, 3, 3,
    3, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1 // These are not exact frequencies but are based on general trends in the English language.
  ];

  var random = Random();
  List<String> selectedLetters = [];

  for (int i = 0; i < count; i++) {
    double randomWeight = random.nextDouble() * weights.reduce((a, b) => a + b);
    for (int j = 0; j < allLetters.length; j++) {
      if (randomWeight < weights[j]) {
        selectedLetters.add(allLetters[j]);
        break;
      } else {
        randomWeight -= weights[j];
      }
    }
  }

  return selectedLetters;
}


