#!/bin/bash

################### TRANSDUCERS ###################

#
### misto2numerico ###
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  mmm2mm.txt | fstarcsort > mmm2mm.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait mmm2mm.fst | dot -Tpdf  > mmm2mm.pdf

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  date2date.txt > date2date.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait date2date.fst | dot -Tpdf  > date2date.pdf

fstconcat  date2date.fst mmm2mm.fst | fstclosure | fstdisambiguate > misto2numerico.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait misto2numerico.fst | dot -Tpdf  > misto2numerico.pdf

#
### pt2en ###
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  mmmen2mmmpt.txt | fstarcsort > mmmen2mmmpt.fst
fstdraw --isymbols=syms.txt --osymbols=syms-out.txt --portrait mmmen2mmmpt.fst | dot -Tpdf  > mmmen2mmmpt.pdf

fstconcat date2date.fst mmmen2mmmpt.fst | fstclosure | fstdisambiguate > en2pt.fst
fstdraw --isymbols=syms.txt --osymbols=syms-out.txt --portrait en2pt.fst | dot -Tpdf  > en2pt.pdf

fstinvert en2pt.fst > pt2en.fst
fstdraw --isymbols=syms.txt --osymbols=syms-out.txt --portrait pt2en.fst | dot -Tpdf  > pt2en.pdf

#
### numerico2texto ###
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
fstdraw --isymbols=syms.txt --osymbols=syms-out.txt --portrait numerico2texto.fst | dot -Tpdf  > numerico2texto.pdf

#
### misto2texto ###
fstcompose misto2numerico.fst numerico2texto.fst | fstclosure > misto2texto.fst
fstdraw --isymbols=syms.txt --osymbols=syms-out.txt --portrait misto2texto.fst | dot -Tpdf > misto2texto.pdf

#
### data2texto ###
fstcompose misto2numerico.fst numerico2texto.fst | fstclosure > data2texto.fst
fstdraw --isymbols=syms.txt --osymbols=syms-out.txt --portrait data2texto.fst | dot -Tpdf > data2texto.pdf

###################  TESTS  ###################

### Creation of test transducers ###
#
# xxxxx_misto
python3 ./scripts/word2fst.py -s syms.txt 25/MAI/2014 > 80845_misto.txt
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  80845_misto.txt |  fstarcsort > 80845_misto.fst
python3 ./scripts/word2fst.py -s syms.txt 25/JUL/2013 > 84980_misto.txt
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  84980_misto.txt |  fstarcsort > 84980_misto.fst
#
# xxxxx_pt
python3 ./scripts/word2fst.py -s syms.txt 25/MAI/2014 > 80845_pt.txt
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  80845_pt.txt |  fstarcsort > 80845_pt.fst
python3 ./scripts/word2fst.py -s syms.txt 25/JUL/2013 > 84980_pt.txt
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  84980_pt.txt |  fstarcsort > 84980_pt.fst
#
# xxxxx_numerico
python3 ./scripts/word2fst.py -s syms.txt 25/05/2014 > 80845_numerico.txt
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  80845_numerico.txt |  fstarcsort > 80845_numerico.fst
python3 ./scripts/word2fst.py -s syms.txt 25/07/2013 > 84980_numerico.txt
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  84980_numerico.txt |  fstarcsort > 84980_numerico.fst

### Transducer Tests ###
#
# xxxxx_misto2numerico
fstcompose 80845_misto.fst misto2numerico.fst > 80845_misto2numerico.fst
echo "80845_misto2numerico:"
fstproject --project_output 80845_misto2numerico.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
fstcompose 84980_misto.fst misto2numerico.fst > 84980_misto2numerico.fst
echo "84980_misto2numerico:"
fstproject --project_output 84980_misto2numerico.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
#
# xxxxx_pt2en
fstcompose 80845_pt.fst pt2en.fst | fstarcsort > 80845_pt2en.fst
echo "80845_pt2en:"
fstproject --project_output 80845_pt2en.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
fstcompose 84980_pt.fst pt2en.fst | fstarcsort > 84980_pt2en.fst
echo "84980_pt2en:"
fstproject --project_output 84980_pt2en.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
#
# xxxxx_numerico2texto
fstcompose 80845_numerico.fst numerico2texto.fst > 80845_numerico2texto.fst
echo "80845_numerico2texto:"
fstproject --project_output 80845_numerico2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
fstcompose 84980_numerico.fst numerico2texto.fst > 84980_numerico2texto.fst
echo "84980_numerico2texto:"
fstproject --project_output 84980_numerico2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
#
# xxxxx_misto2texto
fstcompose 80845_misto.fst misto2texto.fst > 80845_misto2texto.fst
echo "80845_misto2texto:"
fstproject --project_output 80845_misto2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
fstcompose 84980_misto.fst misto2texto.fst > 84980_misto2texto.fst
echo "84980_misto2texto:"
fstproject --project_output 84980_misto2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
#
# xxxxx_data2texto
fstcompose 80845_misto.fst data2texto.fst > 80845_data2texto.fst
echo "80845_data2texto (misto):"
fstproject --project_output 80845_data2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
fstcompose 84980_numerico.fst data2texto.fst > 84980_data2texto.fst
echo "84980_data2texto (numerico):"
fstproject --project_output 84980_data2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'

