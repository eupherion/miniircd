#!/usr/bin/env bash

# Entering script directory
cd "$(dirname "$0")" || exit 1

# Activating virtual environment
source .venv/bin/activate

# Run miniircd with required arguments
./miniircd --listen 0.0.0.0 --motd motd.txt --state-dir ./chans --verbose --log-file miniircd.log
