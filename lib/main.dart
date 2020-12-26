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
    } else if (cmd.startsWith("position")) {
      List info = cmd.split(" ");
      if (info[1] != 'startpos') {
        bot.update_setup(info[1]);
      }
      if (info.length > 3) {
        for (int i = 3; i < info.length; i++) {
          bot.moveLAN(info[i]);
        }
      }
    }
    //print(bot.ascii);
  }
}

void main() {
  run();
}
