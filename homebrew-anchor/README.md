# Homebrew Tap for Anchor ⚓

This is the official Homebrew tap for [Anchor](https://github.com/selimbens/anchor), an AI-powered CLI tool for local LLM knowledge retrieval.

## 🚀 Installation

### Prerequisites
Anchor requires **Ollama** to be installed and running locally for embedding generation.

### Install Anchor
```bash
# Add the tap
brew tap selimbens/anchor

# Install Anchor
brew install anchor
```

## 📋 Setup

### 1. Install and Start Ollama
```bash
# Install Ollama
brew install ollama

# Start Ollama service
brew services start ollama

# Or run manually
ollama serve
```

### 2. Pull Required Models
```bash
# Pull embedding model (required)
ollama pull nomic-embed-text

# Optional: Pull chat models for enhanced functionality
ollama pull llama2
ollama pull mistral
```

### 3. Verify Installation
```bash
# Check Anchor version
anchor --version

# Check Ollama status
curl http://localhost:11434/api/tags

# Test basic functionality
anchor --help
```

## 🔧 Usage

### Ingest Your Knowledge Base
```bash
# Scan and index your markdown notes
anchor ingest /path/to/your/notes

# Example: Index your personal documents
anchor ingest ~/Documents/notes
```

### Ask Questions
```bash
# Query your knowledge base
anchor ask "What is my philosophy on productivity?"

# Find specific information
anchor ask "What were my key decisions about career path?"
```

## 📖 Documentation

- **Full Documentation**: [https://github.com/selimbens/anchor](https://github.com/selimbens/anchor)
- **Ollama Documentation**: [https://ollama.ai](https://ollama.ai)
- **Issues & Support**: [GitHub Issues](https://github.com/selimbens/anchor/issues)

## 🔄 Updates

### Update Anchor
```bash
brew update
brew upgrade anchor
```

### Update Tap Formula
```bash
brew tap-upgrade selimbens/anchor
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Ollama Connection Failed
```bash
# Check if Ollama is running
brew services list | grep ollama

# Start Ollama service
brew services start ollama

# Check Ollama logs
brew services log ollama

# Manual verification
curl http://localhost:11434/api/tags
```

#### 2. Model Not Found
```bash
# List available models
ollama list

# Pull required embedding model
ollama pull nomic-embed-text

# Pull additional models if needed
ollama pull llama2
```

#### 3. Permission Issues
```bash
# Check Ollama service permissions
brew services list

# Restart service if needed
brew services restart ollama
```

### Getting Help
- Check the [main project documentation](https://github.com/selimbens/anchor)
- Search [existing issues](https://github.com/selimbens/anchor/issues)
- Create a [new issue](https://github.com/selimbens/anchor/issues/new)

## 📦 Package Information

### Formula Details
- **Formula**: `anchor`
- **Tap**: `selimbens/anchor`
- **Source**: [github.com/selimbens/anchor](https://github.com/selimbens/anchor)
- **License**: MIT

### Dependencies
- **Build**: Go 1.25+
- **Runtime**: Ollama (external dependency)

## 🤝 Contributing

This tap is maintained alongside the main Anchor project. For contributing to the formula:

1. Check the [main project](https://github.com/selimbens/anchor)
2. Test formula changes locally:
   ```bash
   brew install --build-from-source ./Formula/anchor.rb
   ```
3. Submit issues or PRs to the main repository

## 📄 License

This Homebrew formula is released under the same MIT license as the Anchor project.

---

**Made with ❤️ for the Anchor community**