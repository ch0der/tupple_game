// game_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
// Events
abstract class GameEvent {}

class SubmitGuessEvent extends GameEvent {}

class LoadNewPuzzleEvent extends GameEvent {}

class ScrambleWordsEvent extends GameEvent {}

class SelectWordEvent extends GameEvent {
  final String word;
  SelectWordEvent(this.word);
}

//... Add other events if needed

// States
abstract class GameState {}

class GameInitialState extends GameState {}

class GameUpdatedState extends GameState {
  final List<String> selectedWords;
  //... other properties if necessary

  GameUpdatedState(this.selectedWords);
}

class GameOverState extends GameState {}

//... Add other states if necessary

// GameBloc
class GameBloc extends Bloc<GameEvent, GameState> {
  int currentActiveRow = 0;
  int currentPuzzleIndex = 0;
  List<String> selectedWords = List.filled(6, '');

  // Other game logic variables...
  //...

  GameBloc() : super(GameInitialState());

  Stream<GameState> mapEventToState(GameEvent event) async* {
    if (event is SubmitGuessEvent) {
      // Handle the logic for submitting a guess
      // For instance, if the guess is correct, increase the currentActiveRow and update selectedWords
      // Then, you can yield a new state:
      yield GameUpdatedState(selectedWords);

      // If the game is over:
      yield GameOverState();
    } else if (event is LoadNewPuzzleEvent) {
      // Handle loading a new puzzle
      //...

      yield GameUpdatedState(selectedWords);
    } else if (event is ScrambleWordsEvent) {
      // Handle word scrambling
      //...

      yield GameUpdatedState(selectedWords);
    } else if (event is SelectWordEvent) {
      // Handle word selection, based on the word from the event
      //...

      yield GameUpdatedState(selectedWords);
    }

    // Handle other events...
    //...
  }

// Here, you can also add more methods specific to the GameBloc that can be used by external classes.
// For instance: void resetGame(), void loadRandomPuzzle(), and so on...
}