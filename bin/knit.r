library(knitr);
args = commandArgs(trailingOnly=TRUE)
#knitr::opts_knit$set(root.dir = "../build/");
#knitr::opts_knit$set(base.dir = "../build/");
knitr::opts_knit$set(cache=TRUE);
knitr::opts_knit$set(cache.path = "../_R/cache/");
knitr::opts_chunk$set(cache.path = "../_R/cache/");
#knit_hooks$set(inline = function(x) prettyNum(x, big.mark=","));
#knit_hooks$set(error = function(x, options) stop(x));

fmt <- function(x) format(x, digits=5, big.mark='', small.mark='', small.interval=10)
dfmt <- function(x) {
  # a <- format(x[1], digits=5, small.mark='', small.interval=10);
  a <- round(x[1], digits=5)
  b <- round(x[2], digits=5)
  # b <- format(x[2], digits=5, small.mark='', small.interval=10);
  return(paste(c(a,b), collapse=" \\& "))
}
lfmt <- function(x) lapply(x, function(y) format(y, digits=5, small.mark='', small.interval=10));

make_align_string <- function(x) {
  paste("|",paste(as.character(x), collapse="|"), "|", sep="")
}

xtablex <- function(x, ...) {
  z <- list(...)
  if (is.null(z$align)) {
    a <- align(xtable(x))
    xtable(x, ..., align=make_align_string(a))
  } else {
    a <- align(xtable(x, ...))
    z$x <- x
    z$align <- make_align_string(a)
    do.call(xtable,z)
  }
}


options(digits=3)
options(format.args=list(big.mark=',',small.mark=''))
options(xtable.format.args=list(big.mark=',',small.mark=''))
knitr::opts_chunk$set(fig.path = "../_R/figure/", fig.align="center", fig.show="hold", echo=FALSE);
purl(args[1], quiet=T);
knit(args[1], encoding="UTF-8", quiet=as.logical(args[2]));
