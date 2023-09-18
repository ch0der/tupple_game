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
  List<bool> isUsedList = List.generate(6, (index) => false);

  void initState() {
    super.initState();
  }

  void deselectLetter(int index) {
    setState(() {
      String deselectedLetter = selectedLetters[index];
      selectedLetters[index] = "";

      for (int i = 0; i < sourceLetters.length; i++) {
        if (sourceLetters[i] == deselectedLetter && isUsedList[i]) {
          isUsedList[i] = false;
          break;
        }
      }
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
            Expanded(child: Container()),
            // Destination Tiles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return GestureDetector(
                  onTap: () {
                    deselectLetter(index);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: selectedLetters[index].isEmpty
                          ? BorderRadius.circular(8)
                          : BorderRadius.circular(8),
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
                GameTile tile = GameTile(
                    letter: sourceLetters[index],
                    placement: index,
                    value: index + 1);
                return (TileWidget(
                  isSelected: isUsedList[index],
                  tile: tile,
                  onTap: () {
                    if (!isUsedList[index]) {
                      setState(() {
                        for (int i = 0; i < selectedLetters.length; i++) {
                          if (selectedLetters[i] == "") {
                            selectedLetters[i] = tile.letter;
                            isUsedList[index] = true;
                            break;
                          }
                        }
                      });
                    }
                  },
                ));
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
          color: isSelected ? Colors.grey.withOpacity(_opacity) : Colors.grey.withOpacity(.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.black54.withOpacity(_opacity) : Colors.black, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          tile.letter,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: isSelected ? Colors.black.withOpacity(_opacity) : Colors.black,
          ),
        ),
      ),
    );
  }
}

List<String> generateWeightedRandomLetters(int count) {
  final allLetters = [
    'E',
    'T',
    'A',
    'O',
    'I',
    'N',
    'S',
    'H',
    'R',
    'D',
    'L',
    'C',
    'U',
    'M',
    'W',
    'F',
    'G',
    'Y',
    'P',
    'B',
    'V',
    'K',
    'J',
    'X',
    'Q',
    'Z'
  ];

  final weights = [
    13, 9, 8, 8, 7, 7, 6, 6, 6, 4, 4, 3, 3, 3, 3,
    3, 2, 2, 2, 2, 1, 1, 1, .5, 1,
    1 // These are not exact frequencies but are based on general trends in the English language.
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
