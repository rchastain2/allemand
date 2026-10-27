
SOURCES := ecclesiaste.tex
TARGETS := $(SOURCES:%.tex=%)

all: $(TARGETS)

%: %.tex
	lualatex --jobname=$@ $<

clean:
	rm -fv *.aux *.log *.toc *.out

distclean: clean
	rm -fv *.pdf
