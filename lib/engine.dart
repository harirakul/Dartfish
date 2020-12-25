import "package:chess/chess.dart";

var turns = <String, int>{"w": 1, "b": -1};
var material_values = <String, int>{
  "p": 100,
  "n": 320,
  "b": 330,
  "r": 500,
  "q": 900,
  "k": 10000
};

class Engine extends Chess {
  Engine() : super();
  Engine.fromFEN(String fen) : super.fromFEN(fen);

  double eval() {
    // Basic Material Evaluation
    double score = 0;
    for (int i = 0; i < board.length; i++) {
      if (board[i] is Piece) {
        score += material_values[board[i].type.toString()] *
            turns[board[i].color.toString()];
      }
    }
    return score;
  }
}
