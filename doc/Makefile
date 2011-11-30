DOCS = proposal.tex report.tex

pdf: $(DOCS:.tex=.pdf)

%.dvi: %.tex
	( \
	bibtex $<; \
	latex --interaction=nonstopmode $<; \
	while grep -q "Rerun to get cross-references right." $(<:.tex=.log); do \
		latex $<; \
	done; \
	)

%.pdf: %.dvi
	dvipdfm $<

clean:
	@rm -f \
	texput.log \
	$(DOCS:.tex=.aux) \
	$(DOCS:.tex=.dvi) \
	$(DOCS:.tex=.log) \
	$(DOCS:.tex=.out) \
	$(DOCS:.tex=.pdf) \
	$(DOCS:.tex=.lof) \
	$(DOCS:.tex=.lot) \
	$(DOCS:.tex=.toc) \
	$(DOCS:.tex=.blg) \
	$(DOCS:.tex=.bbl)
