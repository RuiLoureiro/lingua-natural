#!/usr/bin/env python3

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
import nltk
import string
import re
import numpy as np

#replaces tokens and removes stop words
def get_token_dictionary(file_path, token):
	token_file = open(file_path).read()
	token_list = token_file.split('\n')
	#order token list by descending line length, to avoid shorter tokens 
	# matching parts of longer tokens. (.eg 'webb' matching 'webb child').

	token_list.sort(key=len, reverse=True)


	# to deal with txt files that have empty lines
	#token_list = filter(lambda x: not re.match(r'^\s*$', x), token_list)
	token_list = list(filter(None, token_list))

	return dict.fromkeys(token_list, token)

def process_file(input_name):

	token_dictionaries = []

	token_dictionaries.append(get_token_dictionary("recursos/list_movies.txt", "_movie_"))
	token_dictionaries.append(get_token_dictionary("recursos/list_people.txt", "_actor_"))
	token_dictionaries.append(get_token_dictionary("recursos/list_characters.txt", "_character_"))
	token_dictionaries.append(get_token_dictionary("recursos/list_companies.txt", "_company_"))
	token_dictionaries.append(get_token_dictionary("recursos/list_genres.txt", "_genre_"))
	token_dictionaries.append(get_token_dictionary("recursos/list_jobs.txt", "_job_"))
	# This is already working but decreases accuracy from 100% to ~83%
	# token_dictionaries.append(get_token_dictionary("recursos/list_keywords.txt", "_keyword_"))

	output_name = 'processed/' + input_name

	input = open(input_name, "r")
	output = open(output_name, "w")

	stop_words = set(stopwords.words('english'))

	#remove all punctuation
	punctuation_to_remove = string.punctuation.replace('_', '').replace(':', '')

	#
	for line in input:
		new_sentence = line.translate(str.maketrans("", "", punctuation_to_remove))

		for d in token_dictionaries:
			for value, token in d.items():
				if value in new_sentence:
					# Replaces value (as a whole word) in new_sentence for token, if it exists
					new_sentence = re.sub(r"\b" + re.escape(value) + r"\b", token, new_sentence)

		new_sentence = new_sentence.lower()
		
		word_tokens = word_tokenize(new_sentence)
		filtered_sentence = [] 

		for w in word_tokens: 
			if w not in stop_words: 
				filtered_sentence.append(w)

		new_sentence = ' '.join(filtered_sentence)

		output.write(new_sentence + '\n')

def format_corpora(input_name):

	sentences = []
	tags = []

	input = open(input_name, "r")

	for line in input:
		tag, sentence = line.split(" ", 1)

		sentences.append(sentence.strip())
		tags.append(tag.strip())
	
	return sentences, tags

def med(string1, string2):
	insert_cost = 1
	delete_cost = 0
	replace_cost = 1

	size_1 = len(string1) + 1
	size_2 = len(string2) + 1

	matrix = np.zeros((size_1, size_2))

	for x in range(size_1):
		matrix[x, 0] = x
	for y in range(size_2):
		matrix[0, y] = y

	for x in range(1, size_1):
		for y in range(1, size_2):
			if string1[x-1] == string2[y-1]:
				matrix[x, y] = matrix[x-1, y-1]
			else:
				matrix[x, y] = min(matrix[x-1, y] + insert_cost, matrix[x, y-1] + delete_cost, matrix[x-1, y-1] + replace_cost)
				
	return matrix[size_1-1, size_2-1]

def get_tag(corpora_s, corpora_t, s):
	i = 0
	md = 99999
	tokens1 = nltk.word_tokenize(s)

	for i in range(len(corpora_s)):
		tokens2 = nltk.word_tokenize(corpora_s[i])
		d = med(tokens1, tokens2)
		if d < md:
			tag = corpora_t[i]
			md = d
	#print(tag)
	return tag

def predict_tags(corpora_s, corpora_t, input):

	input = open(input, "r")
	predict = []

	for line in input:
		predict.append(get_tag(corpora_s, corpora_t, line.strip()))

	return predict

def get_file(input_name):

	input = open(input_name, "r")

	real = []

	for line in input:
		real.append(line.strip())
	
	return real

def get_accuracy(predicted, real):

	right = 0

	i = 0
	for i in range(len(predicted)):
		if predicted[i] == real[i]:
			right += 1

	accuracy = right * 100 / len(predicted)

	print("Accuracy:", accuracy, "%")