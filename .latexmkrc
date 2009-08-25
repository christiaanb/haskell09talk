# Includes the default latexmk settings in the caes group

my $caes_latexmkrc=`kpsewhich caes_latexmkrc 2>/dev/null`;
$caes_latexmkrc =~ s/\n//;
process_rc_file($caes_latexmkrc);

# Add your own settings below
# $pdflatex = 'xelatex -shell-escape -synctex=1 -output-driver="xdvipdfmx -q -E" %O %S';
