#!/bin/sh

if ! [ -x "$(command -v pip)" ]; then
  echo 'Error: pip is not installed'
  echo 'Install it by running sudo easy_install pip'
  exit 1
else
  pip install -r requirements.txt
fi


