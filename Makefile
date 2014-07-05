#!/usr/bin/make -f
#drives the addId3tags.pl script
#finds all *.m4a files in dir
#Extract metadata 
.PHONY: echotargets clean reallyclean
files := $(basename $(shell ls *.m4a))
targets := $(foreach file,$(files), $(file).mp3 $(file).tag $(file).jpg $(file).chk)
all: $(targets)
echotargets:
	@echo $(files)
	@echo $(targets)
%.mp3: %.m4a
	avconv -i $< -vn -acodec libmp3lame -ac 2 -ab 128k -y $@
%.tag: %.m4a
	AtomicParsley $< -t > $@
	sed -i  's/^Atom "\(....\)" contains: /\1/' $@
%.jpg: %.m4a
	AtomicParsley $< -E
	mv $*_artwork_1.jpg $@
%.chk: %.mp3 %.tag %.jpg
	./addId3tags.pl $*
	touch $@
clean:
	rm -f *.jpg *.tag *.chk
reallyclean: clean
	rm -f *.mp3
	


