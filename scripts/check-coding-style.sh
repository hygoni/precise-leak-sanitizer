#!/bin/bash

REPO_ROOT_DIR=$(git rev-parse --show-toplevel)
CLANG_FORMAT_DIFF=$REPO_ROOT_DIR/scripts/clang-format-diff.py
git diff -U0 --no-color main HEAD | python3 $CLANG_FORMAT_DIFF -p1
