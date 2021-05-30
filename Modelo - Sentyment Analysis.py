#!/usr/bin/python
# -*- coding: UTF-8 -*-

from nltk.sentiment.vader import SentimentIntensityAnalyzer

# Análisis NLTK
x = "Excelente experiencia, producto muy bueno y bonito"
y = "Tuve una experiencia horrible"
z = "No tengo nada que decir. Es un producto normal"

sia = SentimentIntensityAnalyzer()

# Diccionario pares/clave valor
# Expone los porcentajes neg, neutro, positivo y final (compound: de (-1) a (1); de negativo a positivo).

resultados = sia.polarity_scores(x)
print(resultados)


from sentiment_analysis_spanish import sentiment_analysis

# Análisis Spanish
x = "Excelente experiencia, producto muy bueno y bonito"
y = "Tuve una experiencia horrible"
z = "No tengo nada que decir. Es un producto normal"

clf = sentiment_analysis.SentimentAnalysisSpanish()

sentimiento = clf(x)
print(sentimiento)
