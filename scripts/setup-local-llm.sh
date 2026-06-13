#!/bin/bash
set -e

LLAMA_DIR="$HOME/llama/llama.cpp"
MODEL_DIR="$HOME/models"

echo "======================================="
echo "Local DevSecOps LLM Setup"
echo "======================================="

# Install dependencies
echo "Installing dependencies..."

if [ -f /etc/redhat-release ]; then
    sudo dnf install -y \
        git \
        gcc \
        gcc-c++ \
        cmake \
        make \
        wget
else
    echo "Please install Git, GCC, CMake, and Wget manually."
fi

# Clone llama.cpp
if [ ! -d "$LLAMA_DIR" ]; then
    echo "Cloning llama.cpp..."
    mkdir -p "$(dirname "$LLAMA_DIR")"
    git clone https://github.com/ggml-org/llama.cpp.git "$LLAMA_DIR"
else
    echo "llama.cpp already exists."
fi

# Build llama.cpp
echo "Building llama.cpp..."

cd "$LLAMA_DIR"

cmake -B build
cmake --build build -j "$(nproc)"

# Create model directory
mkdir -p "$MODEL_DIR"

echo ""
echo "======================================="
echo "Download a GGUF Model"
echo "======================================="
echo ""
echo "Recommended:"
echo "Qwen2.5-7B-Instruct-Q4_K_M.gguf"
echo ""
echo "Download from:"
echo "https://huggingface.co/Qwen/Qwen2.5-7B-Instruct-GGUF"
echo ""
echo "Place the model in:"
echo "$MODEL_DIR"
echo ""

echo "Example:"
echo "wget <GGUF_DOWNLOAD_URL> -O \\"
echo "  $MODEL_DIR/Qwen2.5-7B-Instruct-Q4_K_M.gguf"

echo ""
echo "Setup completed."
echo ""
echo "To start the model:"
echo "./scripts/run-llm.sh"