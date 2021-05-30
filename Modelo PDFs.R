library("wordcloud2")
library("pdftools")
library("tm")

# ruta donde tengo 100 pdf
my_dir <- "directorio de los pdfs"

# se pasan los pdf a una lista
files <- list.files(path = my_dir, pattern = "pdf$")
files

# se crea un corpus
setwd(my_dir)
corp <- Corpus(URISource(files, encoding = "latin1"),
               readerControl = list(reader = readPDF, language = "es-419"))

# numero de documentos
ndocs <- length(corp)
ndocs

#===========================================================================================#
                                  ## LIMPIEZA DE DATOS ##
#===========================================================================================#

# LIMPIEZA DEL CORPUS #
corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, content_transformer(removePunctuation))
corp <- tm_map(corp, content_transformer(removeNumbers))
corp <- tm_map(corp, removeWords, stopwords("spanish"))
corp <- tm_map(corp, stripWhitespace)


#===========================================================================================#
                                  ## CLUSTERING ##
#===========================================================================================#

# Ignorar palabras extrañas
minTermFreq <- ceiling(ndocs*0.1)

# Ignorar palabras muy comunes
maxTermFreq <- floor(ndocs*0.5)

# SE COMVIERTE EL CORPUS EN UNA TABLA DE CONTINGENCIA
  # 'dtm': matriz de documentos de término. Almacena recuento de término para cada documento.

dtm <- DocumentTermMatrix(corp,
                          control = list(
                            language = "es-419",
                            wordLengths = c(4, 15), # palabras entre 4 y 15 caracteres
                            bounds = list(global = c(minTermFreq, maxTermFreq)) # se dejan fuera los min y max
                          ))

inspect(dtm)

# TABLA DE CONTINGENCIA CON PALABRAS QUE APARECEN EN UN 20% DE LOS PDFs
dtm2 <- removeSparseTerms(dtm, 0.8)
inspect(dtm2)

# PARA VER TODA LA TABLA Y NO SOLO LAS QUE MAS SE REPITEN
M <- as.matrix(dtm)
o <- order(sM <- colSums(M), decreasing = TRUE)
write.csv(M[,o], paste0(my_dir, "DTM.csv"), fileEncoding = "UTF-8")


# NUBE DE PALABRAS
mywords <- data.frame(words = names(sM), freq = as.numeric(sM))
mywords2 <- mywords[mywords$freq > 15,]
wordcloud2(mywords2, fontFamily = "serif",
           backgroundColor = "white", shape = 'pentagon', size = 0.4)


# MATRIZ DE DISTANCIA ENTRE DOCUMENTOS (METODO DE AGRUPAMIENTO JERARQUICO)
distMatrix <- dist(M, method = "euclidean")
groups <- hclust(distMatrix, method = "ward.D")
plot(groups, main = "Dendograma de PDFs", cex=0.9, hang=-1,
     xlab = "", ylab = "Altura")
rect.hclust(groups, k = 9, border="blue")

#===========================================================================================#
                                  ## EXTRACCIÓN DE FECHAS ##
#===========================================================================================#

# guardo los nobres de los pdf en un vector
argumento <- names(corp)


# se printea cada PDf con su respectivo año
for(i in 1:length(argumento)){
  print(paste("la fecha del", argumento[i] ,
              "es", corp[[  i ]][["meta"]][["datetimestamp"]]))
}


# se guardan los años y los nombres de los archivos en los PDFs
todos_archivos <- data.frame()

for(nombre_archivo in argumento){
  df <- data.frame(
    archivo = nombre_archivo,
    fecha = corp[[ nombre_archivo ]][["meta"]][["datetimestamp"]],
    contenido = corp[[nombre_archivo]][["content"]]
  )
  todos_archivos <- rbind(todos_archivos, df)
}

View(todos_archivos)

#===========================================================================================#
                                  ## MATRIZ S.ANALYSIS ##
#===========================================================================================#

library(syuzhet)

frase <- c("Este producto es bueno, excelente servicio")
frase2 <- c("Este producto es malo, pesimo servicio. No compre")

# Función que genera matriz comparativa de S.A
  # Compara paquetes Bing,afinn,nrc,syuzhet

Sent_Matriz <- function(frase){
  syuzhet_vector_1 <- get_sentiment(frase, method="bing")
  syuzhet_vector_2 <- get_sentiment(frase, method="afinn")
  syuzhet_vector_3 <- get_sentiment(frase, method="nrc", lang = 'spanish')
  syuzhet_vector_4 <- get_sentiment(frase, method="syuzhet")

  head(syuzhet_vector_1)
  head(syuzhet_vector_2)
  head(syuzhet_vector_3)
  head(syuzhet_vector_4)

  rbind(
    sign(head(syuzhet_vector_1)),
    sign(head(syuzhet_vector_2)),
    sign(head(syuzhet_vector_3)),
    sign(head(syuzhet_vector_4))
  )
}

Sent_Matriz(frase)
