#!/usr/bin/env python3

from nltk import ngrams
from aux_functions import *
import time
import re


start = time.time()


#add condition to runs processed files only when processed folder is empty!!
#process_file("corpora/QuestoesConhecidas.txt")
#process_file("corpora/NovasQuestoes.txt")


corpora_s, corpora_t = format_corpora("processed/QuestoesConhecidas.txt")


predicted = predict_tags(corpora_s, corpora_t, "processed/NovasQuestoes.txt")

real = get_file("corpora/NovasQuestoesResultados.txt")

get_accuracy(predicted, real)

end = time.time()

elapsed = end - start

print("Time: ", elapsed)


