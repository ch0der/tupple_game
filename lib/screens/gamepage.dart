import 'package:flutter/material.dart';
import 'dart:math';

class TestWordGame extends StatefulWidget {
  const TestWordGame({super.key});

  @override
  State<TestWordGame> createState() => _TestWordGameState();
}

class _TestWordGameState extends State<TestWordGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Word Game"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Spacing between the tiles
              children: List.generate(6, (index) {
                GameTile tile = GameTile(letter: String.fromCharCode(65 + index), placement: index, value: index + 1); // Generating tiles with letters A, B, C, ...

                return TileWidget(
                  tile: tile,
                  onTap: () {
                    print("Tile ${tile.letter} tapped!");
                  },
                );
              }),
            ),
            // ... (other UI elements or Rows of tiles can be added here)
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
        width: 50, // adjust width and height as needed
        height: 50,
        decoration: BoxDecoration(
          color: widget.tile.selected ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),  // rounded corners
          border: Border.all(color: Colors.black54, width: 1),  // border
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

