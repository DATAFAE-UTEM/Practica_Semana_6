#!/usr/bin/python
# -*- coding: UTF-8 -*-

import nltk
from nltk.corpus import stopwords
from nltk.tokenize import sent_tokenize
import re
import string

'''
Paso 1: Se abre el archivo de texto y se le genera una limpieza base;
transformación a minúsculas, eliminación de espacios en blanco, números, puntuación 
y elementos web.
'''
# Carta de contenido y limpieza
with open('out_text.txt', 'r') as miarchivo:
    archivo = miarchivo.read()
    # Se transforma el texto en minúscula
    nuevo_texto = archivo.lower()
    # Eliminación de páginas web (palabras que empiezan por "http")
    nuevo_texto = re.sub('http\S+', ' ', nuevo_texto)
    # Eliminación de signos de puntuación
    regex = '[\\n°\\n\\!\\,\\"\\#\\$\\%\\&\\\'\\(\\)\\*\\+\\-\\\\/\\:\\;\\<\\=\\>\\?\\@\\[\\\\\\]\\^_\\`\\{\\|\\}\\~\\”\\“]' # se descarta .
    nuevo_texto = re.sub(regex, ' ', nuevo_texto)
    # Eliminación de números
    nuevo_texto = re.sub("\d+", ' ', nuevo_texto)
    # Eliminación de espacios en blanco multiples
    nuevo_texto = re.sub("\\s+", ' ', nuevo_texto)
    print(len(nuevo_texto))
    print(nuevo_texto)

# Tokenizamos en Español
stop_words = set(stopwords.words('spanish'))
tokens = sent_tokenize(nuevo_texto)
print(tokens)

# Aplicamos una funcion para encontrar elementos que no estén en puntuación
tokens_clean = list(filter(lambda token: token not in string.punctuation, tokens))
filtro = []

# Ciclo para revisar las palabras que no están en las stopwords
for palabra in tokens_clean:
    if palabra not in stop_words:
        filtro.append(palabra)


print(len(filtro))
print(filtro)

