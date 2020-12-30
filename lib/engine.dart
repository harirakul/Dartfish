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
    if (insufficient_material) {
      return 0;
    }

    if (in_stalemate  || in_threefold_repetition) {
      return -500;
    }

    if (in_checkmate) {
      return 9999999;
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
    for (String a in rows.keys.toList()) {
      for (int i = 1; i < 9; i++) {
        String square = a + i.toString();
        if (get(square) is Piece) {
          if (turns[turn.toString()] == 1) {
            //White's turn
            score += (PieceSquareTables[get(square).type.toString()]
                    [squarenum(square)]) *
                turns[get(square).color.toString()];
          } else {
            // Black's turn
            score += (PieceSquareTables[get(square).type.toString()]
                    [63 - squarenum(square)]) *
                turns[get(square).color.toString()] *
                -1;
          }
        }
      }
    }

    return score;
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

  int squarenum(String square) {
    int multiplier = int.parse(square.substring(square.length - 1)) - 1;
    return 8 * multiplier + rows[square.substring(0, 1)];
  }
}
