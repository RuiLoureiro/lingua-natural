#!/usr/bin/env python3

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
 
import nltk
import string
import re


#replaces tokens and removes stop words

def string_found(string1, string2):
   if re.search(r"\b" + re.escape(string1) + r"\b", string2):
      return True
   return False

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


def format_corpora(input_name):

    sentences = []
    tags = []

    input = open(input_name, "r")

    for line in input:
        tag, sentence = line.split(" ", 1)
        tag = tag.strip()
        sentence = sentence.strip()

        sentences.append(sentence)
        tags.append(tag)
    
    return sentences, tags


def get_tag(corpora_s, corpora_t, s):

    i = 0
    md = 99999
    tokens1 = nltk.word_tokenize(s)

    
    for i in range(len(corpora_s)):
        tokens2 = nltk.word_tokenize(corpora_s[i])
        d = nltk.edit_distance(tokens1, tokens2)
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
            right+=1

    accuracy = right / (len(predicted))

    print("Accuracy: ", accuracy)
    




def process_file(input_name):


    token_dictionaries = []

    token_dictionaries.append(get_token_dictionary("recursos/list_movies.txt", "_movie_"))
    token_dictionaries.append(get_token_dictionary("recursos/list_people.txt", "_actor_"))
    token_dictionaries.append(get_token_dictionary("recursos/list_characters.txt", "_character_"))
    token_dictionaries.append(get_token_dictionary("recursos/list_companies.txt", "_company_"))
    token_dictionaries.append(get_token_dictionary("recursos/list_genres.txt", "_genre_"))
    token_dictionaries.append(get_token_dictionary("recursos/list_jobs.txt", "_job_"))

    #something weird with keyword tokens
    #token_dictionaries.append(get_token_dictionary("recursos/list_keywords.txt", "_keyword_"))

    path, actual_name = input_name.split("/",1)
    output_name = 'processed/' + actual_name

    input = open(input_name, "r")
    output = open(output_name, "w")

    stop_words = set(stopwords.words('english')) 

    #print(token_dictionaries[5])

    #remove all punctuation
    punctuation_to_remove = string.punctuation.replace('_', '').replace(':', '')

    #
    for aline in input:
        new_sentence = aline

        new_sentence = new_sentence.translate(str.maketrans("", "", punctuation_to_remove)) + ' '

        for d in token_dictionaries:
            for value, token in d.items():
                if value + ' ' in new_sentence:
                    new_sentence=new_sentence.replace(value, token)


        new_sentence = new_sentence.lower()
        
        word_tokens = word_tokenize(new_sentence)
        filtered_sentence = [] 

        for w in word_tokens: 
            if w not in stop_words: 
                filtered_sentence.append(w) 
        new_sentence = ' '.join(filtered_sentence)
    
        
        output.write(new_sentence+'\n')
