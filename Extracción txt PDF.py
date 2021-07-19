#!/usr/bin/python
# -*- coding: UTF-8 -*-

# Import libraries
from PIL import Image
import pytesseract
import platform
from pdf2image import convert_from_path
import os

# Ubicacion archivo
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

class lectura:
    poppler_path = r".\drivers\poppler-20.11.0\bin"

    def pdf(self, name_pdf):

        # Path of the pdf
        PDF_file = name_pdf

        '''
        Part #1 : Converting PDF to images
        '''

        # Store all the pages of the PDF in a variable
        if platform.system() == 'Windows':
            pages = convert_from_path(name_pdf, 500)
        else:
            pages = convert_from_path(name_pdf, 500, poppler_path=self.poppler_path)

        # Counter to store images of each page of PDF to image
        image_counter = 1

        # Iterate through all the pages stored above
        for page in pages:
            # Declaring filename for each page of PDF as JPG
            # For each page, filename will be:
            # PDF page 1 -> page_1.jpg
            # PDF page 2 -> page_2.jpg
            # PDF page 3 -> page_3.jpg
            # ....
            # PDF page n -> page_n.jpg
            filename = "page_" + str(image_counter) + ".jpg"

            # Save the image of the page in system
            page.save(filename, 'JPEG')

            # Increment the counter to update filename
            image_counter = image_counter + 1

        '''
        Part #2 - Recognizing text from the images using OCR
        '''

        # Variable to get count of total number of pages
        filelimit = image_counter - 1

        # Creating a text file to write the output
    #    outfile = "out_text.txt"

        # Open the file in append mode so that
        # All contents of all images are added to the same file
    #    f = open(outfile, "a")

        texto_completo = ""

        # Iterate from 1 to total number of pages
        for i in range(1, filelimit + 1):
            # Set filename to recognize text from
            # Again, these files will be:
            # page_1.jpg
            # page_2.jpg
            # ....
            # page_n.jpg
            filename = "page_" + str(i) + ".jpg"

            # Recognize the text as string in image using pytesserct
            text = str(((pytesseract.image_to_string(Image.open(filename)))))

            # The recognized text is stored in variable text
            # Any string processing may be applied on text
            # Here, basic formatting has been done:
            # In many PDFs, at line ending, if a word can't
            # be written fully, a 'hyphen' is added.
            # The rest of the word is written in the next line
            # Eg: This is a sample text this word here GeeksF-
            # orGeeks is half on first line, remaining on next.
            # To remove this, we replace every '-\n' to ''.
            text = text.replace('-\n', '*')

            text_completo = texto_completo + text

            # Finally, write the processed text to the file.
        #    f.write(text)

        # Close the file after writing all the text.
       # f.close()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    os.chdir('C:\\Users\\marti\\OneDrive\\Desktop\\Datas\\PDf - Modelo extracción Py')

# iteracion que extrae el texto de elemento definido
for file in os.listdir():
    lee = lectura()
    lee.pdf(file)