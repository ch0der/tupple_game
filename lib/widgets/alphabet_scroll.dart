import 'package:flutter/material.dart';

class AlphabetScroll extends StatefulWidget {
  final ValueChanged<String> onLetterSelected;

  AlphabetScroll({required this.onLetterSelected});

  @override
  _AlphabetScrollState createState() => _AlphabetScrollState();
}

class _AlphabetScrollState extends State<AlphabetScroll> {
  late ScrollController _controller;
  final List<String> _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    double _size = 35;
    return Container(
      height: 350,
      width: 30,
      child: ListWheelScrollView(


        controller: _controller,
        itemExtent: _size,
        diameterRatio: 1,
        squeeze: 1.25,
        magnification: 2,// Adjust for how "curved" you want the wheel to appear// This provides a "snapping" effect
        onSelectedItemChanged: (int index) {
          widget.onLetterSelected(_alphabet[index]);
        },
        children: _alphabet.map((letter) {
          return Container(
            height: 30,
            width: 30,
            color: Colors.black12,
            child: Center(
              child: Text(

                letter,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
