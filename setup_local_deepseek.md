# Setup Local DeepSeek Models with AutoGPT

This guide will help you set up local DeepSeek models to run with AutoGPT instead of calling external APIs.

## Prerequisites

- Docker and Docker Compose installed
- At least 16GB RAM (32GB+ recommended for larger models)
- 20GB+ free disk space for models

## Step 1: Install Ollama

### Option A: Using Docker (Recommended)
```bash
# Pull the Ollama Docker image
docker pull ollama/ollama

# Run Ollama in the background
docker run -d \
  --name ollama \
  -p 11434:11434 \
  -v ollama:/root/.ollama \
  ollama/ollama
```

### Option B: Direct Installation
```bash
# Install Ollama on Linux
curl -fsSL https://ollama.com/install.sh | sh

# Start Ollama service
ollama serve
```

## Step 2: Download DeepSeek Models

```bash
# Download DeepSeek R1 model (about 8GB)
docker exec ollama ollama pull deepseek-r1

# Download DeepSeek Chat model (about 4GB)
docker exec ollama ollama pull deepseek-chat

# Verify models are installed
docker exec ollama ollama list
```

## Step 3: Configure AutoGPT

The AutoGPT platform has been modified to support local DeepSeek models. You now have access to:

- **OLLAMA_DEEPSEEK_R1**: DeepSeek R1 model running locally
- **OLLAMA_DEEPSEEK_CHAT**: DeepSeek Chat model running locally

## Step 4: Start AutoGPT

```bash
# Navigate to the autogpt_platform directory
cd autogpt_platform

# Start the platform with Docker Compose
docker-compose -f docker-compose.yml up -d
```

## Step 5: Using Local DeepSeek Models

1. Open your browser and go to `http://localhost:3000`
2. Create a new agent or workflow
3. Add an LLM block (AI Text Generator, AI Conversation, etc.)
4. In the model dropdown, select either:
   - **OLLAMA_DEEPSEEK_R1** for the R1 model
   - **OLLAMA_DEEPSEEK_CHAT** for the Chat model
5. Set the Ollama host to `localhost:11434` (or `ollama:11434` if running in Docker)
6. No API key is required for local models!

## Configuration Options

### Custom Ollama Host
If you're running Ollama on a different host or port, update the `ollama_host` parameter in the LLM blocks:

```
Default: localhost:11434
Custom: your-host:your-port
```

### Model Performance
- **DeepSeek R1**: Better for complex reasoning tasks
- **DeepSeek Chat**: Faster responses, good for general conversation

## Troubleshooting

### Models Not Loading
```bash
# Check if Ollama is running
docker ps | grep ollama

# Check Ollama logs
docker logs ollama

# Manually test a model
docker exec ollama ollama run deepseek-r1 "Hello, how are you?"
```

### Connection Issues
- Ensure Ollama is accessible on port 11434
- Check firewall settings
- For Docker setups, ensure proper network connectivity

### Performance Issues
- Increase available RAM
- Consider using GPU acceleration if available
- Use smaller models for faster responses

## Benefits of Local Setup

✅ **No API costs** - Run unlimited requests locally  
✅ **Privacy** - Your data never leaves your machine  
✅ **No rate limits** - No external API restrictions  
✅ **Offline capability** - Works without internet connection  
✅ **Customization** - Full control over model parameters  

## Advanced Configuration

### GPU Acceleration (Optional)
If you have NVIDIA GPUs available:

```bash
# Run Ollama with GPU support
docker run -d \
  --name ollama \
  --gpus all \
  -p 11434:11434 \
  -v ollama:/root/.ollama \
  ollama/ollama
```

### Model Variants
You can also try different model sizes:
```bash
# Smaller, faster models
docker exec ollama ollama pull deepseek-r1:7b
docker exec ollama ollama pull deepseek-chat:7b

# Larger, more capable models (if you have the resources)
docker exec ollama ollama pull deepseek-r1:32b
docker exec ollama ollama pull deepseek-chat:32b
```

## Support

If you encounter issues:
1. Check the Ollama documentation: https://ollama.com/docs
2. Verify your system meets the requirements
3. Test models directly with Ollama before using with AutoGPT
4. Check AutoGPT logs for connection errors

Enjoy running DeepSeek models locally with AutoGPT!