import 'package:flutter/material.dart';
import 'dart:math' as math;

class AlphabetScroll extends StatefulWidget {
  final ValueChanged<String> onLetterSelected;
  final ValueNotifier<String?> selectedLetterNotifier;

  AlphabetScroll({required this.onLetterSelected, required this.selectedLetterNotifier});

  @override
  _AlphabetScrollState createState() => _AlphabetScrollState();
}


class _AlphabetScrollState extends State<AlphabetScroll> {
  final double _size = 60;
  late ScrollController _controller;
  final ValueNotifier<String?> selectedLetterNotifier = ValueNotifier<String?>(null);

  final List<String> _alphabet = '  ABCDEFGHIJKLMNOPQRSTUVWXYZ  '.split('');

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    widget.selectedLetterNotifier.addListener(() {
      final String? selectedLetter = widget.selectedLetterNotifier.value;
      if (selectedLetter != null) {
        final int selectedIndex = _alphabet.indexOf(selectedLetter);
        _controller.animateTo(
          math.max(
              0.0,
              math.min(
                  selectedIndex * _size - (MediaQuery.of(context).size.width * 0.85) / 2 + (_size / 2),
                  _controller.position.maxScrollExtent
              )
          ),
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );

      }
    });
  }

  @override
  void dispose() {
    widget.selectedLetterNotifier.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.85,
      height: 60,
      child: ListView.builder(


        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemCount: _alphabet.length,
        itemBuilder: (context, index) {
          final selectedLetter = widget.selectedLetterNotifier.value;
          final int selectedIndex = selectedLetter != null ? _alphabet.indexOf(selectedLetter) : -1;
          final isHighlighted = (index >= selectedIndex && index <= selectedIndex + 4);
          final isHighlightedNext = (index >= selectedIndex && index <= selectedIndex );
          return Container(
            width: _size,
            height: _size,
            alignment: Alignment.center,
            child: Text(
              _alphabet[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isHighlightedNext ? 32 : 18,
                color: isHighlighted ? Colors.black : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
