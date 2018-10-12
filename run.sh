#!/bin/bash

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  mmm2mm.txt | fstarcsort > mmm2mm.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait mmm2mm.fst | dot -Tpdf  > mmm2mm.pdf

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  date2date.txt > date2date.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait date2date.fst | dot -Tpdf  > date2date.pdf

fstconcat  date2date.fst mmm2mm.fst | fstclosure | fstdisambiguate > misto2numerico.fst

fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait misto2numerico.fst | dot -Tpdf  > misto2numerico.pdf

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  dia.txt > dia.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait dia.fst | dot -Tpdf  > dia.pdf
 

python3 ./scripts/word2fst.py -s syms.txt 10/SET/2018 > dummy_input_date.txt
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  dummy_input_date.txt |  fstarcsort > dummy_input_date.fst

fstcompose dummy_input_date.fst misto2numerico.fst > new_date.fst
echo -n "New date é: "
fstproject --project_output new_date.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'

