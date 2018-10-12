#!/bin/bash

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  mmm2mm.txt | fstarcsort > mmm2mm.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait mmm2mm.fst | dot -Tpdf  > mmm2mm.pdf

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  date2date.txt > date2date.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait date2date.fst | dot -Tpdf  > date2date.pdf

fstconcat  date2date.fst mmm2mm.fst | fstclosure | fstdisambiguate > misto2numerico.fst

fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait misto2numerico.fst | dot -Tpdf  > misto2numerico.pdf

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  dia.txt > dia.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait dia.fst | dot -Tpdf  > dia.pdf

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  mes.txt > mes.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait mes.fst | dot -Tpdf  > mes.pdf

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  2mile.txt > 2mile.fst

fstconcat 2mile.fst dia.fst > ano.fst

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  barra.txt > barra.fst

fstconcat dia.fst barra.fst > diabarra.fst
fstconcat mes.fst barra.fst > mesbarra.fst

fstconcat mesbarra.fst ano.fst > mesbarraano.fst

fstconcat diabarra.fst mesbarraano.fst > numerico2texto.fst


python3 ./scripts/word2fst.py -s syms.txt 25/05/2018 > dummy_numerico.txt

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  dummy_numerico.txt |  fstarcsort > dummy_numerico.fst


fstcompose dummy_numerico.fst numerico2texto.fst > numericoteste.fst

fstproject --project_output numericoteste.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
