#primeiro passo
test -e build || mkdir build
pdflatex -output-directory=build relatorio
if [ $? -eq 0 ]; then
	pdflatex -output-directory=build relatorio
fi

