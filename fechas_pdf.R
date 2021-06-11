library("wordcloud2")
library("pdftools")
library("tm")

# ruta donde tengo 100 pdf
my_dir = "C:\\Users\\panch\\Desktop\\python\\PDFs"

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

##============================================##
# LIMPIEZA DEL CORPUS #
corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, content_transformer(removePunctuation))
corp <- tm_map(corp, content_transformer(removeNumbers))
corp <- tm_map(corp, removeWords, stopwords("spanish"))
corp <- tm_map(corp, stripWhitespace)

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

#===========================================================================================#

#===========================================================================================#

library(tesseract)

# se extrae el texto de un PDF_image
pngfile <- pdftools::pdf_convert("C:\\Users\\panch\\Desktop\\python\\intento\\archivo - 2021-05-07T124627.929.pdf", dpi = 600)
text <- tesseract::ocr(pngfile)
cat(text)



