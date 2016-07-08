pdf=paper

all: build ; make build/$(pdf).pdf

include etc/Makefile.R

Q=-quiet
ifdef Q
	RQ=T
else
	RQ=F
endif

mysrc=$(wildcard src/*.Rnw)
latexmk=../bin/latexmk
latexdiff=../bin/latexdiff


build/$(pdf).pdf: _R/.RData src/paper.bib etc/meta.tex etc/header.tex bin/knit.r $(mysrc) | $(R_REQ)
	cd build; env R_LIBS=$(R_LIBS) Rscript ../bin/knit.r ../src/paper.Rnw $(RQ)
	cd build; TEXINPUTS=../etc:../src:.: BIBINPUTS=../src/: $(latexmk) -pdf $(Q) paper.tex
	rm -rf src/*.sty

_R/.RData: src/stats.R | build _R
	cd build; Rscript -e "source('../src/stats.R'); save.image(file='../_R/.RData')"

require: | $(R_REQ) ; @echo done


clobber:
	rm -rf build _R

clean:
	rm -rf _R
	@touch src/paper.Rnw

mksrc:
	./bin/mksrc.rb $(pdf) > build/full.tex

mkold:
	./bin/mksrc.rb $(pdf) | ./bin/strip.pl > .old.tex

mkdiff:
	./bin/mksrc.rb $(pdf) | sed -e '/^%/d' | ./bin/strip.pl > build/full.tex
	(cd build; $(latexdiff) ../.old.tex full.tex > diff.tex)
	(cd build; $(latexmk) diff.tex)

_R build build/data: ;  mkdir -p $@
