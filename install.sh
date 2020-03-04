#!/bin/bash

NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

echo -e "${YELLOW}Creating symbolic link for .emacs${NOCOLOR}"
ln -sf ./dotemacs ~/.emacs

if [ "$?" == "1" ]; then
    echo -e "${GREEN}File created${NOCOLOR}"
else
    echo -e "${RED}Command unsuccesfull${NOCOLOR}"
fi
