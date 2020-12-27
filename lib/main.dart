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
    } else if (cmd.startsWith("go")) {
      print("bestmove " + bot.play());
    }
    if (cmd.startsWith("position")) {
      if (cmd.contains('/')) {
        if (cmd.contains('moves')) {
          const start = "position ";
          const end = " moves";
          int startIndex = cmd.indexOf(start);
          int endIndex = cmd.indexOf(end, startIndex + start.length);
          bot =
              Engine.fromFEN(cmd.substring(startIndex + cmd.length, endIndex));
          List moves = cmd.substring(cmd.indexOf(end) + end.length).split(" ");
          for (String move in moves) {
            bot.moveLAN(move);
          }
        } else {
          bot = Engine.fromFEN(cmd.substring(9));
        }
      } else {
        List info = cmd.split(" ");
        if (info[1] == 'startpos') {
          bot = Engine();
        }
        if (info.length > 3) {
          for (int i = 3; i < info.length; i++) {
            bot.moveLAN(info[i]);
          }
        }
      }
    }
    //print(bot.ascii);
  }
}

void main() {
  run();
}
