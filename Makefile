FILE		= clash-haskell09
LHS2TEX = lhs2TeX -v --poly --haskell
LATEXMK = latexmk -pdf
RM			= rm -f
RSVG    = rsvg-convert --format=pdf

LHSRCS = \
	introduction.lhs \
	PolyAlu.lhs \
	reducer.lhs \
	howdoesitwork.lhs \
	demo.lhs \
	summery.lhs

LHFORMATS = \
	talk.fmt
	
TEXSRCS = \
  preamble.tex

SVGFIGURES = \
  mealymachine.svg \
  mealymachine2.svg \
  simpleCPU.svg \
  reducer.svg

default: clash-haskell09

clash-haskell09: texs figs $(TEXSRCS) $(LHFORMATS)
	$(LHS2TEX) $(FILE).lhs > $(FILE).tex; \
	$(LATEXMK) $(FILE); \
	open $(FILE).pdf; \
	$(RM) $(LHSRCS:.lhs=.tex)

texs : $(LHSRCS:.lhs=.tex) 
%.tex : %.lhs
	$(LHS2TEX) $< > $@

figs : $(SVGFIGURES:.svg=.pdf)
%.pdf : %.svg
	$(RSVG) $< > $@

clean:
		latexmk -CA clash-haskell09
		$(RM) $(SVGFIGURES:.svg=.pdf)
		$(RM) $(FILE).tex
		$(RM) $(FILE).ptb
		$(RM) $(FILE).synctex.gz
		$(RM) $(FILE).nav
		$(RM) $(FILE).snm
		$(RM) *.hi *.o *.aux