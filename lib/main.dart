import "package:chess/chess.dart";

void main() {
  Chess chess = new Chess();
  print('position: ' + chess.fen);
  print(chess.ascii);
  // var moves = chess.moves();
  // moves.shuffle();
  // print(moves);
  chess.move({"from": 'g2', "to": 'g3'});
  print(chess.ascii);
  // print('move: ' + move);
  // sleep(Duration(seconds: 1));
}
