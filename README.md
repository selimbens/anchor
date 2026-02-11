# Anchor ⚓

A lightweight, zero-dependency CLI tool for personal knowledge retrieval. It turns your markdown notes into a searchable "Second Brain" using local vector embeddings.

## Core Philosophy
- **Grounded**: Built in Go for speed and zero runtime dependencies.
- **Sovereign**: All data stays local. No cloud, no tracking.
- **Purposeful**: Designed to help you maintain consistency between your actions and your principles.

## Usage

### 1. Ingest Knowledge
Scan a directory to index your thoughts. It splits files by headers and generates embeddings using Ollama.
```bash
anchor ingest /path/to/your/notes
```

### 2. Ask Questions
Query your knowledge base to find relevant principles or past decisions.
```bash
anchor ask "What is my philosophy on presence?"
```

## Installation & Uninstallation

### 1. The "Go Native" Way (Recommended for Developers)
If your `$GOPATH/bin` is in your `$PATH`:

**Install:**
```bash
go install github.com/selimbens/anchor@latest
```

**Uninstall:**
```bash
rm $(go env GOPATH)/bin/anchor
```

---

### 2. The "Makefile" Way (Manual/Global Control)
**Install:**
```bash
make install
```

**Uninstall:**
```bash
make uninstall
```

---

### 3. The "Homebrew" Way (For macOS/Darwin)
To use this method, you will need to create a Homebrew Formula. Once set up:

**Install:**
```bash
brew install selimbens/tap/anchor
```

**Uninstall:**
```bash
brew uninstall anchor
```

## Setup Requirements
- **Go**: Required for building from source.
- **Ollama**: Must be running locally.
- **Model**: `nomic-embed-text` must be pulled (`ollama pull nomic-embed-text`).

## Data Storage
Your "anchors" are stored in a local JSON file: `.anchor_store.json`.

## Development Setup

### Prerequisites
- **Go 1.25+**: Required for building from source
- **Ollama**: Must be running locally for embeddings
- **Make**: Optional but recommended for development tasks

### Quick Start for Developers
```bash
# Clone the repository
git clone https://github.com/selimbens/anchor.git
cd anchor

# Set up development environment
make setup-dev

# Start development with hot reload
make dev

# Run tests
make test

# Build for your platform
make build

# Build for all platforms
make build-all
```

### Development Commands
```bash
# Build and test
make test-coverage

# Format code
make fmt

# Lint code
make lint

# Security scan
make security

# Clean build artifacts
make clean

# Install locally
make install PREFIX=/usr/local

# Validate release configuration
make validate-release

# Create release snapshot
make release-snapshot
```

### Makefile Targets
- **`make build`**: Build for current platform
- **`make build-all`**: Build for all platforms (Linux, macOS, Windows)
- **`make test`**: Run unit tests
- **`make test-coverage`**: Run tests with HTML coverage report
- **`make fmt`**: Format Go code using gofmt
- **`make lint`**: Run golangci-lint for code quality
- **`make dev`**: Start development server with hot reload
- **`make setup-dev`**: Install development tools (air, golangci-lint, gosec, goreleaser)
- **`make deps`**: Update and clean Go modules
- **`make security`**: Run security scan using gosec

## Continuous Integration & Deployment

### Automated Releases
This project uses **GoReleaser** for automated releases:

1. **Multi-Platform Builds**: Automatically builds for Linux, macOS, and Windows (amd64/arm64)
2. **Homebrew Tap**: Automatic updates to `selimbens/homebrew-anchor` tap
3. **GitHub Releases**: Automatic creation of GitHub releases with checksums
4. **Docker Images**: Automatic build and push to GitHub Container Registry

### Release Process
```bash
# Create a new release (triggers automated pipeline)
git tag v1.0.0
git push origin v1.0.0

# Or create release snapshot for testing
make release-snapshot
```

### Testing & Quality Assurance
- **Unit Tests**: Comprehensive test coverage with race condition detection
- **Integration Tests**: Test with real Ollama service
- **Static Analysis**: golangci-lint with 20+ linters
- **Security Scanning**: gosec for vulnerability detection
- **CI/CD Pipeline**: GitHub Actions for automated testing and releases

## Contributing

### Development Workflow
1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Set up** development environment: `make setup-dev`
4. **Make** your changes with hot reload: `make dev`
5. **Test** your changes: `make test`
6. **Format** your code: `make fmt`
7. **Lint** your code: `make lint`
8. **Commit** your changes with detailed commit messages
9. **Push** and create a Pull Request

### Code Quality Standards
- **Formatting**: Use `gofmt` and `goimports` for consistent formatting
- **Testing**: Write unit tests for new functionality
- **Documentation**: Update README and inline comments
- **Security**: Run `make security` before committing

## Next Steps (Sovereignty Path)
- [x] **Enhanced .gitignore**: Comprehensive patterns for modern Go development
- [x] **Homebrew Integration**: Complete tap with automatic formula updates
- [x] **Release Automation**: GoReleaser with multi-platform support
- [x] **Development Infrastructure**: Makefile, testing, and CI/CD pipeline
- [ ] **Global Installation**: Move the binary to `/usr/local/bin` to use it anywhere.
- [ ] **Automated Ingest**: Add a git hook or cron job to re-ingest your `personal-assist` repo daily.
- [ ] **Agent Integration**: Instruct your AI agents to use `anchor ask` before suggesting career or technical advice.
- [ ] **Performance Optimization**: Add incremental ingestion and caching for large repositories.
- [ ] **Advanced Search**: Add semantic search capabilities and filtering.
