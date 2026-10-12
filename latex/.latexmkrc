# 編譯：在 latex/ 執行  latexmk main.tex
$pdf_mode = 5;            # xelatex
$out_dir = 'build';
$aux_dir = 'build';
$xelatex = 'xelatex -interaction=nonstopmode -halt-on-error -file-line-error %O %S';
# nomencl 符號列表
add_cus_dep('nlo', 'nls', 0, 'makenlo2nls');
sub makenlo2nls { system("makeindex \"$_[0].nlo\" -s nomencl.ist -o \"$_[0].nls\""); }
# glossaries
add_cus_dep('glo', 'gls', 0, 'makeglo2gls');
sub makeglo2gls { system("makeglossaries -d build \"$_[0]\""); }
$clean_ext = 'nlo nls glo gls glg ist bbl run.xml';
# 編譯成功後複製成品到 thesis/pdf/
$success_cmd = 'internal copypdf';
sub copypdf { use File::Copy; copy('build/main.pdf', '../pdf/thesis.pdf') or warn "複製 PDF 失敗(檔案被開啟中?): $!\n"; return 0; }
