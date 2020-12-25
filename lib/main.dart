import "engine.dart";

void main() {
  Engine e = new Engine.fromFEN('1rr1k3/4p1b1/6Q1/q2Pp3/4P3/2p2PN1/P3N1K1/R6R b - - 0 31');
  print(e.eval());
}
