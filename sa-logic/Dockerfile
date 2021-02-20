# Docker will install python-slim-buster
FROM python:3.6-slim-buster

# Then data will cpoied from current to app directory
COPY . /app

# Now working directory is app 
WORKDIR /app

# Run the update in ubuntu
RUN apt update -y

# Installing the libgill-mesa-dev library
RUN apt-get install -y libgl1-mesa-dev

# Installing the tesseract-ocr -y library
RUN apt-get install tesseract-ocr -y

# Installing the tesseract-ocr-spa -y library
RUN apt-get install tesseract-ocr-spa -y

# Installing dependences from requirements.txt
RUN pip install -r requirements.txt

# Installing pytsseract
RUN pip install pytesseract

# Installing tsseract 
RUN pip install tesseract

# It will give the path for present working directory 
RUN pwd

# It will show you ead-write permission
RUN ls -lrt

# It will run the python program on this server($PORT)
CMD python app.py runserver 0.0.0.0:8080