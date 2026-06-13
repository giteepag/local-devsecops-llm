#!/bin/bash

MODEL="$HOME/models/Qwen2.5-7B-Instruct-Q4_K_M.gguf"
LLAMA="$HOME/llama/llama.cpp/build/bin/llama-cli"

# Verify model exists
if [ ! -f "$MODEL" ]; then
    echo "ERROR: Model not found:"
    echo "$MODEL"
    exit 1
fi

# Verify llama-cli exists
if [ ! -x "$LLAMA" ]; then
    echo "ERROR: llama-cli not found:"
    echo "$LLAMA"
    exit 1
fi

echo "Loading Qwen 2.5 7B..."
echo "Type /exit or press Ctrl+C to quit."
echo ""

"$LLAMA" \
    -m "$MODEL" \
    -t "$(nproc)" \
    -c 8192 \
    -cnv