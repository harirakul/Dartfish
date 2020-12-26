import 'dart:io';
import "engine.dart";

var commands = <String, List>{
  "uci": ["id name Dartfish", "id author Hari Ambethkar", "uciok"],
  "isready": ["readyok"],
};

void run() {
  Engine bot = new Engine();
  while (true) {
    String cmd = stdin.readLineSync();
    if (commands.containsKey(cmd)) {
      for (String out in commands[cmd]) {
        print(out);
      }
    } 
    else if (cmd == "go") {
      print("bestmove " + bot.play()[1]);
    }
  }
}

void main() {
  run();
}