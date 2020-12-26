import 'dart:math';
import "package:chess/chess.dart";
import 'consts.dart';

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
    if (in_stalemate || insufficient_material || in_threefold_repetition) {
      return 0;
    }

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

  String play() {
    List best = minimax(fen, 2, true);
    move(best[1]);
    var lastMove = getHistory({"verbose": true}).last;
    String lanstr = lastMove['from'] + lastMove['to'];
    if (lastMove['flags'].contains('p')) {
      String san = lastMove['san'].toString().toLowerCase();
      lanstr += san.substring(san.length - 1);
    }
    return lanstr;
  }

  bool moveLAN(String lanstr) {
    if (lanstr == "e1g1" && get('e1').type == 'k') {
      return move("O-O");
    }

    if (lanstr == "e1c1" && get('e1').type == 'k') {
      return move("O-O-O");
    }

    var coords = {'from': lanstr.substring(0, 2), 'to': lanstr.substring(2, 4)};
    if (lanstr.length > 4) {
      coords['promotion'] = lanstr[4].toLowerCase();
    }
    return move(coords);
  }
}
