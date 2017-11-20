#!/usr/bin/env bash
set –euo pipefail
if [ $# -lt 1  ]; then
    echo "Usage : $0 txt_file out_file"
    exit;
fi

