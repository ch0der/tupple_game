import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_utils.dart';

// Events
abstract class GameEvent {}

class SubmitGuessEvent extends GameEvent {}

class LoadNewPuzzleEvent extends GameEvent {
  final List<String> newPuzzle;
  LoadNewPuzzleEvent(this.newPuzzle);
}

class ScrambleWordsEvent extends GameEvent {}

class SelectWordEvent extends GameEvent {
  final String word;
  final int index;
  SelectWordEvent(this.word, this.index);
}

// States
abstract class GameState {}

class GameInitialState extends GameState {}

class GameUpdatedState extends GameState {
  final List<String> selectedWords;
  final List<bool> isTileUsedList;
  final List<String> hologramWords;

  GameUpdatedState(this.selectedWords,this.hologramWords,this.isTileUsedList);
}
class DeselectLetterEvent extends GameEvent {
  final int index;
  DeselectLetterEvent(this.index);
}
class AlphabetSelectedEvent extends GameEvent {
  final String letter;

  AlphabetSelectedEvent(this.letter);
}
class LetterSelectedFromSourceEvent extends GameEvent {
  final String letter;
  LetterSelectedFromSourceEvent(this.letter);
}

class LetterTappedInScrollerEvent extends GameEvent {
  final String letter;
  LetterTappedInScrollerEvent(this.letter);
}



class GameOverState extends GameState {}

// GameBloc
class GameBloc extends Bloc<GameEvent, GameState> {
  List<bool> isTileUsedList = List.filled(6, false);

  int currentActiveRow = 0;
  int currentPuzzleIndex = 0;
  List<String> sourceLetters =[];
  List<String> selectedWords = List.filled(6, '');
  List<String> hologramLetters = List.filled(6, '');
  List<int> usedTileIndices = List.filled(6, -1);

  GameBloc() : super(GameInitialState()) {
    on<SubmitGuessEvent>((event, emit) {
      // Handle the logic for submitting a guess
      emit(GameUpdatedState(selectedWords,hologramLetters,isTileUsedList));

      // If the game is over:
      emit(GameOverState());
    });

    on<LoadNewPuzzleEvent>((event, emit) {
      // Handle loading a new puzzle
      List<String> newSourceTiles = generateWeightedRandomLetters(6);
      List<String> emptyHologram = List.filled(6, '');
      usedTileIndices.fillRange(0, 6, -1);
      emit(GameUpdatedState(newSourceTiles,emptyHologram,isTileUsedList));
    });
    on<DeselectLetterEvent>((event, emit) {
      selectedWords[event.index] = "";
      hologramLetters[event.index] = "";

      if (usedTileIndices[event.index] != -1) {
        isTileUsedList[usedTileIndices[event.index]] = false;
        usedTileIndices[event.index] = -1;  // Resetting for future use
      }
      print(usedTileIndices);

      emit(GameUpdatedState(selectedWords, hologramLetters, isTileUsedList));
    });




    on<ScrambleWordsEvent>((event, emit) {
      // Handle word scrambling
      emit(GameUpdatedState(selectedWords,hologramLetters,isTileUsedList));
    });

    on<SelectWordEvent>((event, emit) {
      // 1. Find the index of the first empty slot in destinationWords

      int firstEmptyIndex = selectedWords.indexOf('');
      isTileUsedList[event.index] = true;

      // Check if there's any empty slot available
      if (firstEmptyIndex != -1) {
        // 2. Set the tapped letter to that index
        selectedWords[firstEmptyIndex] = event.word;

        int hologramLetterCode = event.word.codeUnitAt(0) + firstEmptyIndex + 1;
        if (hologramLetterCode > 'Z'.codeUnitAt(0)) {
          hologramLetterCode -= 26;  // 26 letters in the alphabet
        }
        usedTileIndices[firstEmptyIndex] = event.index;
        hologramLetters[firstEmptyIndex] = String.fromCharCode(hologramLetterCode);
      }

      emit(GameUpdatedState(selectedWords,hologramLetters,isTileUsedList));
    });
  }
}
