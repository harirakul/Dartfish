build:
	dart2native lib/main.dart -o bin/dartfish.exe

build-linux:
	dart2native lib/main.dart -o bin/dartfish

run:
	dart run lib/main.dart

run-exe:
	bin\dartfish.exe