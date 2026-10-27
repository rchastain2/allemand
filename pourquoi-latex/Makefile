
SOURCES := $(wildcard *.tex)
TARGETS := $(SOURCES:%.tex=%)

LUALATEX := lualatex

all: $(TARGETS)

%: %.tex
	@$(LUALATEX) --jobname=$@ $<

clean:
	@rm -fv *.aux *.log *.toc *.out

distclean: clean
	@rm -fv *.pdf
