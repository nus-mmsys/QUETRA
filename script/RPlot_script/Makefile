all: fig4a-crop.pdf fig4b-crop.pdf

fig4b-crop.pdf: fig4b.pdf
	pdfcrop fig4b.pdf

fig4a-crop.pdf: fig4a.pdf
	pdfcrop fig4a.pdf

fig4a.pdf: plot.r
	Rscript plot.r

fig4b.pdf: plot.r
	Rscript plot.r
