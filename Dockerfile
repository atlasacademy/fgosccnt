FROM python:3.8-slim-buster

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    git \
    libopencv-core-dev \
    libglib2.0-0 \
    # for SVM
    libsm6 libxrender1 libxext-dev \
    # for OCR
    tesseract-ocr \
    && curl -L -o /usr/share/tesseract-ocr/4.00/tessdata/eng.traineddata https://github.com/tesseract-ocr/tessdata_best/blob/master/eng.traineddata?raw=true


COPY . /app
RUN cd /app \
    && git clone https://github.com/fgosc/fgoscdata.git \
    && pip install --no-cache -r /app/requirements.txt \
    && python3 makeitem.py \
    && python3 makechest.py \
    && python3 makecard.py \
    && mkdir -p /input \
    && mkdir -p /output

ENTRYPOINT python3 /app/fgosccnt.py --folder /parser/input --out_folder /parser/output --lang eng watch
