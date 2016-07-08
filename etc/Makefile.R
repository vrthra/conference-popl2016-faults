R_REQ_LIBS=ggplot2 dplyr scales reshape2 xtable mgcv knitr ezknitr tidyr broom MutCoupling MuPapers
R_LIBS=~/.R/library
R_REQ=$(addprefix .R/,$(R_REQ_LIBS))
urlbase=http://web.engr.oregonstate.edu/~gopinatr/popl17/

.R/MutCoupling: | build build/data .R
	curl $(urlbase)/MutCoupling_1.0.tar.gz -o build/data/MutCoupling_1.0.tar.gz
	cd build/data; cat MutCoupling_1.0.tar.gz| gzip -dc | tar -xvpf - ; cd MutCoupling; R CMD INSTALL .
	@touch $@

.R/MuPapers: | build build/data .R
	curl $(urlbase)../MuPapers_1.0.tar.gz -o build/data/MuPapers_1.0.tar.gz
	cd build/data; cat MuPapers_1.0.tar.gz| gzip -dc | tar -xvpf - ; cd MuPapers; R CMD INSTALL .
	@touch $@

.R/%: | $(R_LIBS) .R
	env R_LIBS=$(R_LIBS) Rscript ./bin/rinst $*
	@touch $@

$(R_LIBS): ; mkdir -p $(R_LIBS)

.R: ; mkdir -p .R

