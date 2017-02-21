

.PHONY: clean compile play

#
# Targets
#

all: ./target/chase.nes

clean:
	rm -rf ./target

target:
	mkdir target

target/game.s: target src/game.c
	cc65 --include-dir ./src -Oi src/game.c --add-source -o ./target/game.s

target/crt0.o: src/crt0.s
	ca65 src/crt0.s --include-dir ./src -o target/crt0.o

target/game.o: target/game.s
	ca65 target/game.s -o target/game.o

target/chase.nes: target/game.o target/crt0.o
	ld65 -C src/nrom_128_horz.cfg -o target/chase.nes target/crt0.o target/game.o src/runtime.lib

play: target/chase.nes
	fceux ./target/chase.nes
