#!/bin/sh
set -eu
test -f desktop/shell/main.c
test -f desktop/shell/Makefile
echo shell-smoke: PASS
