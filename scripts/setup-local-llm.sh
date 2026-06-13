```bash
#!/bin/bash
set -e

##############################################
# Local LLM Launcher
# Supports:
#   1. Console Chat
#   2. API Server
#   3. Web UI (Open WebUI)
##############################################

MODEL_PATH="${MODEL_PATH:-$HOME/models/Qwen2.5-7B-Instruct-Q4_K_M.gguf}"
LLAMA_DIR="${LLAMA_DIR:-$HOME/llama/llama.cpp}"

LLAMA_CLI="${LLAMA_DIR}/build/bin/llama-cli"
LLAMA_SERVER="${LLAMA_DIR}/build/bin/llama-server"

API_PORT=8080
WEBUI_PORT=3000
THREADS=$(nproc)
CONTEXT=8192

usage() {
    echo ""
    echo "Usage: $0 {console|api|webui|all|stop}"
    echo ""
    echo "Commands:"
    echo "  console   Start interactive chat"
    echo "  api       Start OpenAI-compatible API server"
    echo "  webui     Start Open WebUI"
    echo "  all       Start API server + Web UI"
    echo "  stop      Stop API server and Web UI"
    echo ""
    exit 1
}

check_model() {
    if [ ! -f "$MODEL_PATH" ]; then
        echo "ERROR: Model not found:"
        echo "  $MODEL_PATH"
        exit 1
    fi
}

start_console() {
    check_model

    echo "Starting console chat..."

    "$LLAMA_CLI" \
        -m "$MODEL_PATH" \
        -t "$THREADS" \
        -c "$CONTEXT" \
        -cnv
}

start_api() {
    check_model

    if pgrep -f llama-server >/dev/null; then
        echo "API server already running"
        return
    fi

    echo "Starting API server on port ${API_PORT}..."

    nohup "$LLAMA_SERVER" \
        -m "$MODEL_PATH" \
        -t "$THREADS" \
        -c "$CONTEXT" \
        --host 0.0.0.0 \
        --port "$API_PORT" \
        > llama-server.log 2>&1 &

    sleep 5

    if curl -s "http://localhost:${API_PORT}/health" | grep -q "ok"; then
        echo "✓ API Server started"
        echo "  URL: http://localhost:${API_PORT}"
    else
        echo "✗ API Server failed"
        echo "Check logs:"
        echo "tail -f llama-server.log"
    fi
}

start_webui() {

    if ! command -v docker >/dev/null; then
        echo "Docker not found."
        echo "Install Docker first."
        exit 1
    fi

    if docker ps | grep -q open-webui; then
        echo "Open WebUI already running"
        return
    fi

    echo "Starting Open WebUI..."

    docker run -d \
        --name open-webui \
        --restart unless-stopped \
        -p ${WEBUI_PORT}:8080 \
        -e OPENAI_API_BASE_URL=http://host.docker.internal:${API_PORT}/v1 \
        -e OPENAI_API_KEY=dummy \
        --add-host=host.docker.internal:host-gateway \
        -v open-webui:/app/backend/data \
        ghcr.io/open-webui/open-webui:main

    echo ""
    echo "✓ Open WebUI started"
    echo "  URL: http://localhost:${WEBUI_PORT}"
}

stop_all() {

    echo "Stopping API server..."

    pkill -f llama-server || true

    echo "Stopping Open WebUI..."

    docker stop open-webui >/dev/null 2>&1 || true
    docker rm open-webui >/dev/null 2>&1 || true

    echo "✓ Services stopped"
}

##############################################

case "${1:-}" in
    console)
        start_console
        ;;
    api)
        start_api
        ;;
    webui)
        start_webui
        ;;
    all)
        start_api
        start_webui

        echo ""
        echo "==================================="
        echo "Local LLM Environment Ready"
        echo "==================================="
        echo "API   : http://localhost:${API_PORT}"
        echo "WebUI : http://localhost:${WEBUI_PORT}"
        ;;
    stop)
        stop_all
        ;;
    *)
        usage
        ;;
esac
```