# this fails, why
#   $ echo "22↑ 22→ " | perl -pe 's/[↑]/X/g'
#   22XXX 22XX 

$_ = "22↑ 22→ \n";

s/[↑]/X/g;

print;