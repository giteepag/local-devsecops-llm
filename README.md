# Local DevSecOps LLM

Run a local Large Language Model (LLM) on RHEL/Linux using llama.cpp and Qwen2.5-7B-Instruct.

## Features

- Fully local execution
- No external API dependencies
- Optimized for DevSecOps use cases
- Supports Infrastructure-as-Code reviews
- CI/CD pipeline analysis
- Security report summarization

## Requirements

- RHEL 9 / Ubuntu
- 16–32 GB RAM
- 8 CPU cores recommended

## Quick Start

```bash
git clone https://github.com/giteepag/local-devsecops-llm.git
cd local-devsecops-llm

chmod +x scripts/setup-local-llm.sh
./scripts/setup-local-llm.sh

Download the GGUF model:

```bash
mkdir -p ~/models

wget "<GGUF_DOWNLOAD_URL>" \
  -O ~/models/Qwen2.5-7B-Instruct-Q4_K_M.gguf
```

Start chatting:

```bash
chmod +x scripts/run-llm.sh
./scripts/run-llm.sh
```
