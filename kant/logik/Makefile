SOURCES := ${wildcard *.tex}
TARGETS := $(SOURCES:%.tex=%)

all: $(TARGETS)

%: %.tex
	lualatex --jobname=$@ $<

clean:
	rm -rf *.aux
	rm -rf *.log
