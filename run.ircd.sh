#!/usr/bin/env bash

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=> Changing to script directory${NC}"
cd "$(dirname "$0")" || { echo -e "${RED}Error: Failed to change to script directory${NC}" && exit 1; }

echo -e "${GREEN}=> Checking for directories ./chans and ./chlog${NC}"

# Check/create directory for channel state
if [ ! -d "./chans" ]; then
    echo -e "${GREEN}=> Creating directory ./chans${NC}"
    mkdir -p ./chans
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to create directory ./chans (check permissions)${NC}"
        exit 1
    fi
fi

# Check/create directory for channel logs
if [ ! -d "./chlog" ]; then
    echo -e "${GREEN}=> Creating directory ./chlog${NC}"
    mkdir -p ./chlog
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to create directory ./chlog (check permissions)${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}=> Activating virtual environment${NC}"
if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate || { echo -e "${RED}Error: Failed to activate virtual environment${NC}" && exit 1; }
else
    echo -e "${RED}Error: Virtual environment not found (${PWD}/.venv)${NC}"
    exit 1
fi

echo -e "${GREEN}=> Starting miniircd${NC}"
./miniircd --listen 0.0.0.0 --motd motd.txt --state-dir ./chans --channel-log-dir ./chlog --verbose --log-file miniircd.log