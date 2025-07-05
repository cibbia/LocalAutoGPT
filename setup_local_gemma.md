# Setup Local Gemma Models with AutoGPT

This guide will help you set up local Gemma models to run with AutoGPT instead of calling external APIs.

## Prerequisites

- Docker and Docker Compose installed
- At least 8GB of RAM (16GB+ recommended)
- 10GB+ free disk space
- Linux, macOS, or Windows with WSL2

## Step 1: Install and Start Ollama

First, we'll set up Ollama to run the local models:

```bash
# Pull and run Ollama container
docker run -d \
  --name ollama \
  -p 11434:11434 \
  -v ollama:/root/.ollama \
  ollama/ollama

# Wait a moment for it to start
sleep 10

# Test that Ollama is running
curl http://localhost:11434/api/tags
```

## Step 2: Download Gemma Models

Download the Gemma 2B model:

```bash
# Download Gemma 2B model (about 1.7GB)
docker exec ollama ollama pull gemma:2b
```

## Step 3: Verify Models Are Installed

```bash
# List installed models
docker exec ollama ollama list
```

The AutoGPT platform has been modified to support local Gemma models. You now have access to:

- **OLLAMA_GEMMA_2B**: Gemma 2B model running locally

## Step 4: Start AutoGPT

Navigate to the autogpt_platform directory and start the services:

```bash
cd autogpt_platform
docker compose -f docker-compose.yml up -d
```

Wait for all services to start (this may take a few minutes on first run).

## Step 5: Using Local Gemma Models

1. Open your browser to `http://localhost:3000`
2. Create a new agent or edit an existing one
3. Add an AI block (like "AI Text Generator" or "AI Chat")
4. In the model dropdown, select:
   - **OLLAMA_GEMMA_2B** for the 2B model
5. Set the Ollama host to: `localhost:11434`
6. No API key required!

## Model Capabilities

- **Gemma 2B**: Fast and efficient for most tasks

## Testing Your Setup

Test the model directly with Ollama:

```bash
# Test Gemma 2B
docker exec ollama ollama run gemma:2b "Hello, how are you?"
```

## Configuration Details

The following files have been modified to support local Gemma models:

1. **autogpt_platform/backend/backend/blocks/llm.py**
   - Added `OLLAMA_GEMMA_2B` model definition

2. **autogpt_platform/backend/backend/data/block_cost_config.py**
   - Set local models to 0 cost (free)

## Advanced Configuration

### Using Different Model Sizes

If you have more resources, you can also download larger models:

```bash
# Other available Gemma models
docker exec ollama ollama pull gemma:7b
docker exec ollama ollama pull gemma:27b
```

### Performance Tuning

For better performance:
- Increase Docker memory limit to 16GB+
- Use SSD storage for the Ollama volume
- Close other memory-intensive applications

## Troubleshooting

### Models Not Loading
- Check available disk space: `docker system df`
- Verify Docker has enough memory allocated
- Check Ollama logs: `docker logs ollama`

### Connection Issues
- Ensure Ollama is running: `docker ps | grep ollama`
- Test API endpoint: `curl http://localhost:11434/api/tags`
- Check port 11434 is available: `netstat -tlnp | grep 11434`

### Performance Issues
- Monitor system resources: `docker stats`
- Consider using smaller models if running out of memory
- Close unnecessary applications

## Stopping the Services

To stop everything:

```bash
# Stop AutoGPT
cd autogpt_platform
docker compose down

# Stop Ollama
docker stop ollama
```

## Completely Removing Everything

If you want to start fresh:

```bash
# Stop and remove containers
docker stop ollama
docker rm ollama

# Remove the volume (this deletes downloaded models)
docker volume rm ollama

# Remove AutoGPT containers
cd autogpt_platform
docker compose down -v
```

Enjoy running Gemma models locally with AutoGPT!