
SOURCES := $(wildcard *.tex)
TARGETS := $(SOURCES:%.tex=%)

LUALATEX := lualatex

all: $(TARGETS)

%: %.tex
	@$(LUALATEX) --jobname=$@ $<

clean:
	@rm -fv *.aux *.log

distclean: clean
	@rm -fv *.pdf
