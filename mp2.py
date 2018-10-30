#!/usr/bin/env python3

from nltk import ngrams
from aux_functions import *
import time
import re


start = time.time()

process_file("corpora/QuestoesConhecidas.txt")

end = time.time()

elapsed = end - start

print("Time: ", elapsed)


