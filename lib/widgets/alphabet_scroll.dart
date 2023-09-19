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
    double _size = 45;
    return Container(
      height: 60,
      child: ListView.builder(

        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemCount: _alphabet.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _controller.animateTo(
                index * _size,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
              widget.onLetterSelected(_alphabet[index]);
            },
            child: Container(
              width: _size,
              alignment: Alignment.center,
              child: Text(
                _alphabet[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
