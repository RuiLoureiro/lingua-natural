#!/usr/bin/env python3

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize 
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
    token_list = filter(None, token_list) # to deal with txt files that have an empty (last) line
    return dict.fromkeys(token_list, token)


def process_file(input_name):


    token_dictionaries = []

    token_dictionaries.append(get_token_dictionary("recursos/list_people.txt", "_actor"))
    token_dictionaries.append(get_token_dictionary("recursos/list_movies.txt", "_movie_"))
    token_dictionaries.append(get_token_dictionary("recursos/list_companies.txt", "_company"))
    token_dictionaries.append(get_token_dictionary("recursos/list_characters.txt", "_character_"))
    token_dictionaries.append(get_token_dictionary("recursos/list_genres.txt", "_genre_"))
    token_dictionaries.append(get_token_dictionary("recursos/list_jobs.txt", "_job_"))
    #token_dictionaries.append(get_token_dictionary("recursos/list_keywords.txt", "_keyword_"))

    path, actual_name = input_name.split("/",1)
    output_name = 'processed/' + actual_name

    input = open(input_name, "r")
    output = open(output_name, "w")

    stop_words = set(stopwords.words('english')) 

    #print(token_dictionaries[5])

    for aline in input:
        new_sentence = aline

        new_sentence = new_sentence.translate(str.maketrans("", "", string.punctuation)) + ' '

        for d in token_dictionaries:
            for value, token in d.items():
                if value + ' ' in new_sentence:
                    new_sentence=new_sentence.replace(value, token)
        
        word_tokens = word_tokenize(new_sentence)
        filtered_sentence = [] 

        for w in word_tokens: 
            if w not in stop_words: 
                filtered_sentence.append(w) 
        new_sentence = ' '.join(filtered_sentence)
    
        
        output.write(new_sentence+'\n')
