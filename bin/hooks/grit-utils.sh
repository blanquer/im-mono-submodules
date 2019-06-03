#!/bin/bash

# Utilities

GRIT_PREFIX="Grit:"
info() {
  local blue='\033[0;34m'
  GRIT="${blue}${GRIT_PREFIX}\033[0m"
  printf "$GRIT $1\n"
}
warn() {
  local red='\033[0;33m'
  GRIT="${red}${GRIT_PREFIX}\033[0m"
  printf "$GRIT $1\n"
}

err() {
  local red='\033[0;31m'
  GRIT="${red}${GRIT_PREFIX}\033[0m"
  printf "$GRIT $1\n"
}
