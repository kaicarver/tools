# this fails, why:
#   $ echo "22↑ 22→ " | perl -pe 's/[↑]/X/g'
#   22XXX 22XX 
# this no better:
#   $ echo "22↑ 22→ " | perl -Mutf8 -pe 's/[↑]/X/g'
#   22↑ 22→
# solution:
#   $ echo "22↑ 22→ " | perl -Mutf8 -CS -pe 's/[↑]/X/g'
#   22X 22→ 

use utf8;
use open ':std', ':encoding(UTF-8)'; # avoid "Wide character in print at test.pl line 13."

$_ = "22↑ 22→ \n";

#s/[↑]/X/g;
s/([0-2][0-9])([↑]) \1([→]) /\1\2\3 /g;

print;
