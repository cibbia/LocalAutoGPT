#!/bin/bash

# Setup Local Gemma Models with AutoGPT
# This script automates the installation and configuration of Gemma models locally

set -e

echo "🚀 Setting up local Gemma models for AutoGPT..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    print_status "Docker is installed ✓"
}

# Check if Docker Compose is installed
check_docker_compose() {
    if ! docker compose version &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    print_status "Docker Compose is installed ✓"
}

# Setup Ollama
setup_ollama() {
    print_status "Setting up Ollama..."
    
    # Check if Ollama container is already running
    if docker ps | grep -q ollama; then
        print_warning "Ollama container is already running. Stopping it first..."
        docker stop ollama || true
        docker rm ollama || true
    fi
    
    # Pull Ollama image
    print_status "Pulling Ollama Docker image..."
    docker pull ollama/ollama
    
    # Run Ollama container
    print_status "Starting Ollama container..."
    docker run -d \
        --name ollama \
        -p 11434:11434 \
        -v ollama:/root/.ollama \
        ollama/ollama
    
    # Wait for Ollama to be ready
    print_status "Waiting for Ollama to be ready..."
    sleep 10
    
    # Check if Ollama is responding
    max_retries=30
    retry_count=0
    
    while [ $retry_count -lt $max_retries ]; do
        if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
            print_status "Ollama is ready ✓"
            break
        fi
        echo -n "."
        sleep 2
        retry_count=$((retry_count + 1))
    done
    
    if [ $retry_count -eq $max_retries ]; then
        print_error "Ollama failed to start properly"
        exit 1
    fi
}

# Download Gemma models
download_models() {
    print_status "Downloading Gemma models..."
    
    # Gemma 2B model
    print_status "Downloading Gemma 2B model (this may take several minutes)..."
    docker exec ollama ollama pull gemma:2b
    
    # Verify models are installed
    print_status "Verifying installed models..."
    docker exec ollama ollama list
}

# Test models
test_models() {
    print_status "Testing Gemma models..."
    
    # Test Gemma 2B
    print_status "Testing Gemma 2B..."
    docker exec ollama ollama run gemma:2b "Hello! Please respond with just 'Gemma 2B is working'" --timeout 30
}

# Display final instructions
show_instructions() {
    print_status "Setup complete! 🎉"
    echo ""
    echo "Your local Gemma models are now ready to use with AutoGPT."
    echo ""
    echo "Next steps:"
    echo "1. Navigate to the autogpt_platform directory"
    echo "2. Start AutoGPT with: docker compose -f docker-compose.yml up -d"
    echo "3. Open http://localhost:3000 in your browser"
    echo "4. Create agents using the following local models:"
    echo "   - OLLAMA_GEMMA_2B (for efficient local inference)"
    echo "5. Set Ollama host to: localhost:11434"
    echo "6. No API key required!"
    echo ""
    echo "For more details, see the setup_local_gemma.md file."
}

# Main execution
main() {
    echo "🔧 AutoGPT Local Gemma Setup"
    echo "============================="
    echo ""
    
    # Check prerequisites
    check_docker
    check_docker_compose
    
    # Setup Ollama
    setup_ollama
    
    # Download models
    download_models
    
    # Test models
    test_models
    
    # Show final instructions
    show_instructions
}

# Handle script interruption
trap 'echo -e "\n${RED}Setup interrupted by user${NC}"; exit 1' INT

# Run main function
main "$@"