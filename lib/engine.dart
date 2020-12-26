import 'dart:math';

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

double inf = 100000;

List minimax(String position, int depth, bool maxPlayer) {
  if (depth == 0 || Chess.fromFEN(position).in_checkmate) {
    return [Engine.fromFEN(position).eval(), position];
  }

  if (maxPlayer) {
    double maxEval = -inf;
    String bestMove = null;
    for (var move in Chess.fromFEN(position).moves()) {
      Chess board = Chess.fromFEN(position);
      board.move(move);
      double eval = minimax(board.fen, depth - 1, false)[0];
      maxEval = max(maxEval, eval);
      if (maxEval == eval) {
        bestMove = move;
      }
    }
    return [maxEval, bestMove];
  } else {
    double minEval = inf;
    String bestMove = null;
    for (var move in Chess.fromFEN(position).moves()) {
      Chess board = Chess.fromFEN(position);
      board.move(move);
      double eval = minimax(board.fen, depth - 1, true)[0];
      minEval = min(minEval, eval);
      if (minEval == eval) {
        bestMove = move;
      }
    }
    return [minEval, bestMove];
  }
}

class Engine extends Chess {
  Engine() : super();
  Engine.fromFEN(String fen) : super.fromFEN(fen);

  double eval() {
    // Basic Material Evaluation

    double score = 0;
    for (int i = 0; i < board.length; i++) {
      if (board[i] is Piece) {
        score += material_values[board[i].type.toString()] *
            turns[board[i].color.toString()] *
            turns[turn.toString()];
      }
    }
    return score;
  }

  String compute() {
    String bestMove = null;
    double bestScore = -inf;
    var legals = moves();
    print(legals);

    for (int i = 0; i < legals.length; i++) {
      move(legals[i]);
      if (-eval() > bestScore) {
        bestScore = -eval();
        bestMove = legals[i];
      }
      undo_move();
    }
    return bestMove;
  }

  List play() {
    List best = minimax(fen, 2, true);
    move(best[1]);
    return best;
  }
}
