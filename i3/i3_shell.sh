#!/bin/bash
# script to open a new terminal on the current directory
WHEREAMI=$(cat /tmp/whereami)
cd $WHEREAMI && kitty
