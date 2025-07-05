# 🚀 Local DeepSeek Setup for AutoGPT

Great! I've modified your AutoGPT platform to support local DeepSeek models instead of external APIs. Here's how to get started:

## Quick Start

1. **Run the setup script**:
   ```bash
   ./setup_local_deepseek.sh
   ```

2. **Start AutoGPT**:
   ```bash
   cd autogpt_platform
   docker-compose -f docker-compose.yml up -d
   ```

3. **Open in browser**: `http://localhost:3000`

4. **Use local models**: Select `OLLAMA_DEEPSEEK_R1` or `OLLAMA_DEEPSEEK_CHAT` in your AI blocks

## What's Changed

✅ **Added local DeepSeek models**: 
- `OLLAMA_DEEPSEEK_R1` - For complex reasoning tasks
- `OLLAMA_DEEPSEEK_CHAT` - For general conversation

✅ **Zero API costs**: Models run completely locally

✅ **No external API calls**: Your data stays private

✅ **Full offline capability**: Works without internet

## File Changes Made

- `autogpt_platform/backend/backend/blocks/llm.py`: Added local DeepSeek model definitions
- `autogpt_platform/backend/backend/data/block_cost_config.py`: Added cost configuration (set to 0 for local models)

## Requirements

- Docker & Docker Compose
- 16GB+ RAM (32GB+ recommended)
- 20GB+ free disk space
- Linux/macOS (Windows with WSL2)

## Detailed Instructions

For complete setup instructions, see: `setup_local_deepseek.md`

## Troubleshooting

If you encounter issues:
1. Check that Docker is running: `docker ps`
2. Verify Ollama is accessible: `curl http://localhost:11434/api/tags`
3. Test models directly: `docker exec ollama ollama run deepseek-r1 "Hello"`

## Support

The setup script handles everything automatically. If you need help:
1. Check the logs: `docker logs ollama`
2. Restart Ollama: `docker restart ollama`
3. Re-run the setup script

Enjoy your local DeepSeek models! 🎉