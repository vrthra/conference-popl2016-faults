## ----stats, echo=F-------------------------------------------------------
library(ggplot2)
library(knitr)
library(xtable)
load('../_R/.RData')

## ----abstract, child='abstract.Rnw'--------------------------------------



## ----setup, include=FALSE, cache=FALSE, message=FALSE, echo=FALSE--------
render_listings()

library(reshape2)
library(plyr)

library(scales)
library(xtable)
library(ggplot2)
library(grid)
theme = theme_set(theme_minimal())
knit_hooks$set(error = function(x, options) stop(x));
knit_hooks$set(inline = function(x) prettyNum(x, big.mark=","));

## ----a,message=F, echo=F-------------------------------------------------
library(MuPapers)
v=data(package='MuPapers')
data(list = v$results[,3])

library(MutCoupling)
v=data(package='MutCoupling')
data(list = v$results[,3])

## ------------------------------------------------------------------------

## ----introduction, child='introduction.Rnw'------------------------------

## ----terms, child='terms.Rnw'--------------------------------------------




## ----related, child='related.Rnw'----------------------------------------



## ----theory, child='theory.Rnw'------------------------------------------

## ----cubes, child='fig.cubes.Rnw'----------------------------------------



## ----recursion, child='fig.recursion.Rnw'--------------------------------



## ----lines, child='fig.lines.Rnw'----------------------------------------




## ----methodology, child='methodology.Rnw'--------------------------------

## ----results='asis'------------------------------------------------------
names(subjects) <- c('Projects', 'SLOC', 'TLOC', 'CPatches', 'Fails')
print(xtablex(subjects, caption='Apache Projects'), floating=F);

## ----results='asis'------------------------------------------------------
coupled <- subset(hom, coupled == 'y')
subsuming <- subset(hom, subsuming != 'n')
nonsubsuming <- subset(hom, subsuming == 'n')
strongsubsuming <- subset(hom, subsuming == '+')
weaksubsuming <- subset(hom, subsuming == '.')

data <- data.frame(count=integer(0))
data['All','count'] <- nrow(hom)
data['Coupled','count'] <- nrow(coupled)
data['Subsuming','count'] <- nrow(subsuming)
data['Strongly Subsuming','count'] <- nrow(strongsubsuming)
data['Strongly Subsuming and Coupled','count'] <- nrow(subset(strongsubsuming, coupled == 'y'))
data['Weakly Subsuming and Coupled','count'] <- nrow(subset(weaksubsuming, coupled == 'y'))
data['Weakly Subsuming and De-coupled','count'] <- nrow(subset(weaksubsuming, coupled == 'n'))
data['Non Subsuming and De-coupled','count'] <- nrow(subset(nonsubsuming, coupled == 'n'))
data['Non Subsuming and Coupled','count'] <- nrow(subset(nonsubsuming, coupled == 'y'))
x <- xtablex(data)
align(x)[2] <- 'l'
print(x, floating=F)


## ----analysis, child='analysis.Rnw'--------------------------------------

## ----results='asis', fig.height=4, out.width='.99\\linewidth', echo=F, message=F, warn=F,fig.lp="fig:"----
ggplot(faults.x.2.100, aes(y=I(SeparateFaults - RemovedFaults),x=SeparateFaults)) +
  geom_point(aes(color=project), size=1) +
  theme(legend.position="none") +
  scale_y_log10() +
  scale_x_log10() +
  labs(x='Test fails for separated faults', y='Test fails for combined Faults') + #, title='All Projects: \\couplingC')
  theme(text = element_text(size=18))

## ----results='asis', fig.height=4, out.width='.99\\linewidth', echo=F, message=F, warn=F,fig.lp="fig:"----
ggplot(faults.x.2.100, aes(y=JoinedFaults,x=SeparateFaults)) +
  geom_point(aes(color=project), size=1) +
  theme(legend.position="none") +
  scale_y_log10() +
  scale_x_log10() +
  labs(x='Test fails for separated faults', y='Test fails for combined Faults') + #, title='All Projects: general coupling')
  theme(text = element_text(size=18))

## ----results='asis', fig.height=4, out.width='.99\\linewidth', echo=F, message=F, warn=F,fig.lp="fig:"----
faults.math <- faults.math.x.100
faults.math$l <- factor(log2(faults.math$power))
ggplot(faults.math, aes(y=I(SeparateFaults - RemovedFaults),x=SeparateFaults)) +
  geom_point(aes(color=l), size=1) +
  #theme(legend.position="top") +
  scale_y_log10() +
  scale_x_log10() +
  labs(x='Test fails for separated faults', y='Test fails for combined faults') + #, title='Math: \\couplingC')
  theme(text = element_text(size=18), legend.justification=c(1,0), legend.position=c(1,0)) +
  scale_colour_discrete(name="Combinations",
    breaks=c(1, 2, 3, 4, 5, 6),
    labels=c("2", "4", "8", "16", "32", "64"))

## ----results='asis', fig.height=4, out.width='.99\\linewidth', echo=F, message=F, warn=F,fig.lp="fig:"----
ggplot(faults.math, aes(y=JoinedFaults,x=SeparateFaults)) +
  geom_point(aes(color=l), size=1) +
  #theme(legend.position="top") +
  scale_y_log10() +
  scale_x_log10() +
  labs(x='Test fails for separated faults', y='Test fails for combined faults') + #, title='Math: general coupling')
  theme(text = element_text(size=18), legend.justification=c(1,0), legend.position=c(1,0)) +
  scale_colour_discrete(name="Combinations",
    breaks=c(1, 2, 3, 4, 5, 6),
    labels=c("2", "4", "8", "16", "32", "64"))


## ----results, child='results.Rnw'----------------------------------------

## ------------------------------------------------------------------------
fmt <- function(x) format(x, digits=5)

## ----results='asis'------------------------------------------------------
ares.lm <- lm(SeparateFaults-RemovedFaults~0+SeparateFaults,data=faults.x.2.100)
ares <- summary(ares.lm)
print(xtablex(ares), floating=F)

## ----results='asis'------------------------------------------------------
asres.lm <- lm(JoinedFaults~SeparateFaults,data=faults.x.2.100)
asres <- summary(asres.lm)
print(xtablex(asres), floating=F)

## ----results='asis'------------------------------------------------------
xasres.lm <- lm(JoinedFaults~0+SeparateFaults,data=faults.x.2.100)
xasres <- summary(xasres.lm)
print(xtablex(xasres), floating=F)

## ----results='asis'------------------------------------------------------
colnames(faults.x.2.100) <-  c('project','number','SeparateFaults',
                               'JoinedFaults','RemovedFaults','AddedFaults')
x <- aggregate(.~project, faults.x.2.100[,-c(7)], mean)
rownames(x) <- x$project
x <- subset(x, select=-c(1,2))
print(xtablex(x), floating=F, include.rownames=T)

## ----results='asis'------------------------------------------------------
mres.lm <- lm(I(SeparateFaults-RemovedFaults)~0+SeparateFaults,data=faults.math.x.100)
mres <- summary(mres.lm)
print(xtablex(mres), floating=F)

## ----results='asis'------------------------------------------------------
msres.lm <- lm(JoinedFaults~SeparateFaults,data=faults.math.x.100)
msres <- summary(msres.lm)
print(xtablex(msres), floating=F)

## ----results='asis'------------------------------------------------------
xmsres.lm <- lm(JoinedFaults~0+SeparateFaults,data=faults.math.x.100)
xmsres <- summary(xmsres.lm)
print(xtablex(xmsres), floating=F)

## ----results='asis'------------------------------------------------------
colnames(faults.math.x.100) <-  c('project','power','number','SeparateFaults',
                               'JoinedFaults','RemovedFaults','AddedFaults')
x <- aggregate(.~power, faults.math.x.100[,-c(1)], mean)
rownames(x) <- x$power
x <- subset(x, select=-c(1,2))
print(xtablex(x), floating=F, include.rownames=T)


## ----discussion, child='discussion.Rnw'----------------------------------



## ----threats, child='threats.Rnw'----------------------------------------



## ----conclusion, child='conclusion.Rnw'----------------------------------



