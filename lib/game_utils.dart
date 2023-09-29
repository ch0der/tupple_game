import 'package:flutter/material.dart';
import 'dart:math';
List<String> alphabet = [
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
  'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
];

List<String> generateWeightedRandomLetters(int count) {
  if (count < 1) return [];  // Ensure count is at least 1

  final allLetters = [
    'E', 'T', 'A', 'O', 'I', 'N', 'S', 'H', 'R', 'D', 'L', 'C', 'U',
    'M', 'W', 'F', 'G', 'Y', 'P', 'B', 'V', 'K', 'J', 'X', 'Q', 'Z'
  ];

  final vowels = ['A', 'E', 'I', 'O', 'U'];

  final weights = [
    13, 9, 8, 8, 7, 7, 6, 6, 6, 4, 4, 3, 3, 3, 3,
    3, 2, 2, 2, 2, 1, 1, 1, .5, 1,
    1
  ];

  var random = Random();
  List<String> selectedLetters = [];

  // First, select a random vowel.
  selectedLetters.add(vowels[random.nextInt(vowels.length)]);

  // Now, select the rest of the letters using your method.
  for (int i = 1; i < count; i++) {
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
