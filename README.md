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

wget "https://huggingface.co/Qwen/Qwen2.5-7B-Instruct-GGUF" \
  -O ~/models/Qwen2.5-7B-Instruct-Q4_K_M.gguf
```

Start chatting:

```bash
chmod +x scripts/run-llm.sh
./scripts/run-llm.sh
```

## Example Session

```text
Loading Qwen 2.5 7B...
Type /exit or press Ctrl+C to quit.

Loading model...

▄▄ ▄▄
██ ██
██ ██  ▀▀█▄ ███▄███▄  ▀▀█▄    ▄████ ████▄ ████▄
██ ██ ▄█▀██ ██ ██ ██ ▄█▀██    ██    ██ ██ ██ ██
██ ██ ▀█▄██ ██ ██ ██ ▀█▄██ ██ ▀████ ████▀ ████▀
                                    ██    ██
                                    ▀▀    ▀▀

build      : b9586-76da2450a
model      : Qwen2.5-7B-Instruct-Q4_K_M.gguf
modalities : text

available commands:
  /exit or Ctrl+C     stop or exit
  /regen              regenerate the last response
  /clear              clear the chat history
  /read <file>        add a text file
  /glob <pattern>     add text files using globbing pattern

> hi

Hello! How can I assist you today?

[ Prompt: 23.7 t/s | Generation: 7.7 t/s ]

> what is helm ? explain helm chart folder structure

Helm is a package manager for Kubernetes. It simplifies the deployment, scaling, and management of applications on Kubernetes. Helm charts are the packages that Helm uses to install and manage Kubernetes applications.

### Helm Chart Folder Structure

A Helm chart is a directory that contains a structured set of files and subdirectories. The structure of a Helm chart typically includes:

1. `Chart.yaml`
   - Contains chart metadata such as name, version, and description.

2. `values.yaml`
   - Contains default configuration values that can be overridden during installation.

3. `templates/`
   - Stores Kubernetes manifest templates.

4. `charts/`
   - Contains chart dependencies.

5. `templates/_helpers.tpl`
   - Stores reusable template helpers.

6. `templates/NOTES.txt`
   - Displays post-installation instructions.
```

