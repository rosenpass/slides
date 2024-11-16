$pdf_mode=4;

# compatbility setting. 
# this is only necessary for installations using minted versions < 3.0
$lualatex = 'lualatex -shell-escape';

$do_cd=1;

 ensure_path('TEXINPUTS','../tex//','../graphics/');
 ensure_path('LUAINPUTS','../tex//','../graphics/');
 ensure_path('OSFONTDIR', '../tex//');

@default_files=("*/*slides.tex");
