#!/bin/sh
set -eu
for t in tests/*-smoke.sh; do "$t"; done
