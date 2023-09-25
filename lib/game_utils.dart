import 'package:flutter/material.dart';
import 'dart:math';
List<String> alphabet = [
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
  'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
];

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




