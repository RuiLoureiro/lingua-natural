#!/usr/bin/env python3

import sys
from aux_functions import *
import time

#start = time.time()

#add condition to runs processed files only when processed folder is empty!!
process_file(sys.argv[1])
process_file(sys.argv[2])

corpora_s, corpora_t = format_corpora("processed/" + sys.argv[1])

predicted = predict_tags(corpora_s, corpora_t, "processed/" + sys.argv[2])

for i in predicted:
	print(i)

real = get_file("corpora/NovasQuestoesResultados.txt")

#get_accuracy(predicted, real)

#end = time.time()

#elapsed = end - start

#print("Time:", elapsed, "seconds")