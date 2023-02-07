#!/usr/bin/env bash

# More information can be found at: https://linuxhint.com/install-tesseract-ocr-linux/

echo "Installing tesseract: ENG FRA"
#sudo apt-get install tesseract-ocr-
brew install tesseract
#sudo apt-get install tesseract-ocr-fra
brew install tesseract-lang

echo "Installing imagemagick"
brew install imagemagick

# basic usage:
# tesseract [image_name] [output file_name]

