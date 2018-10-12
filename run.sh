#!/bin/bash

################### Item a. ###################

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  mmm2mm.txt | fstarcsort > mmm2mm.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait mmm2mm.fst | dot -Tpdf  > mmm2mm.pdf

fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  date2date.txt > date2date.fst
fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait date2date.fst | dot -Tpdf  > date2date.pdf

fstconcat  date2date.fst mmm2mm.fst | fstclosure | fstdisambiguate > misto2numerico.fst

fstdraw    --isymbols=syms.txt --osymbols=syms-out.txt --portrait misto2numerico.fst | dot -Tpdf  > misto2numerico.pdf

################### Item b. ###################
#
# Generates the binary (fst) and graphic (pdf) transducers to translate mmm format months from english to portuguese
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  mmmen2mmmpt.txt | fstarcsort > mmmen2mmmpt.fst
fstdraw --isymbols=syms.txt --osymbols=syms-out.txt --portrait mmmen2mmmpt.fst | dot -Tpdf  > mmmen2mmmpt.pdf

# Generates the binary transducer used to translate mixed dates from english to portuguese
fstconcat date2date.fst mmmen2mmmpt.fst | fstclosure | fstdisambiguate > en2pt.fst

# Generates the binary transducer used to translate mixed dates from portuguese to english
fstinvert en2pt.fst > pt2en.fst

################### e. Tests ###################
#
### a. misto2numerico ###
sudo python3 ./scripts/word2fst.py -s syms.txt 25/JUL/2013 > 84980_misto.txt
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  84980_misto.txt |  fstarcsort > 84980_misto.fst
# Rui
#sudo python3 ./scripts/word2fst.py -s syms.txt 25/SET/2013 > 84980_pt.txt
#fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  84980_pt.txt |  fstarcsort > 84980_pt.fst

fstcompose 84980_misto.fst misto2numerico.fst > 84980_misto2numerico.fst
echo -n "84980 misto2numerico: "
fstproject --project_output 84980_misto2numerico.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
# Rui
#fstcompose 84980_misto.fst misto2numerico.fst > 84980_misto2numerico.fst
#echo -n "84980 misto2numerico: "
#fstproject --project_output 84980_misto2numerico.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'

#
### b. pt2en ###
sudo python3 ./scripts/word2fst.py -s syms.txt 25/JUL/2013 > 84980_pt.txt
fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  84980_pt.txt |  fstarcsort > 84980_pt.fst

# Rui
#sudo python3 ./scripts/word2fst.py -s syms.txt 25/SET/2013 > 84980_pt.txt
#fstcompile --isymbols=syms.txt --osymbols=syms-out.txt  84980_pt.txt |  fstarcsort > 84980_pt.fst

fstcompose 84980_pt.fst pt2en.fst | fstarcsort > 84980_pt2en.fst
echo -n "84980 pt2en: "
fstproject --project_output 84980_pt2en.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'
# Rui
#fstcompose 84980_pt.fst pt2en.fst | fstarcsort > 84980_pt2en.fst
#echo -n "84980 completed 18 years on: "
#fstproject --project_output 84980_pt2en.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=syms.txt | awk '{print $3}'



