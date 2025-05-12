# ignore font cache changes
$hash_calc_ignore_pattern{'luc'}='^';

ensure_path('TEXINPUTS','../tex//','../global-assets//');
ensure_path('LUAINPUTS','../tex//','../global-assets//');
ensure_path('OSFONTDIR', '../tex//','../global-assets//');
$pdf_mode=4;
$bibtex_use=2;

$do_cd=1;
@default_files=("*slides.tex","**/*slides.tex");
