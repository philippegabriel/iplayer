#!/usr/bin/make -f
%.tag: %.m4a
	AtomicParsley $< -t > $@
%.jpg: %.m4a
	AtomicParsley $< -E
	mv $*_artwork_1.jpg $@
test:
	./test.pl test



