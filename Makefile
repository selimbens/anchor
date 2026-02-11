# Makefile for Anchor ⚓

BINARY_NAME=anchor
PREFIX?=/usr/local
VERSION?=$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
BUILD_DATE?=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
GIT_COMMIT?=$(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
LDFLAGS=-ldflags "-X github.com/selimbens/anchor/cmd/version.Version=$(VERSION) -X github.com/selimbens/anchor/cmd/version.GitCommit=$(GIT_COMMIT) -X github.com/selimbens/anchor/cmd/version.BuildDate=$(BUILD_DATE) -s -w"

# Go build flags
GO_BUILD_FLAGS=CGO_ENABLED=0
GOOS?=$(shell go env GOOS)
GOARCH?=$(shell go env GOARCH)

# Directories
DIST_DIR=dist
BIN_DIR=bin

# Colors for output
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

.PHONY: all build build-all install uninstall clean test lint fmt deps dev release help

# Default target
all: build

# Build for current platform
build:
	@echo "$(BLUE)🔨 Building $(BINARY_NAME) for $(GOOS)/$(GOARCH)...$(NC)"
	$(GO_BUILD_FLAGS) go build $(LDFLAGS) -o $(BINARY_NAME) main.go
	@echo "$(GREEN)✅ Build completed: $(BINARY_NAME)$(NC)"

# Build for all platforms
build-all:
	@echo "$(BLUE)🏗️ Building $(BINARY_NAME) for all platforms...$(NC)"
	@mkdir -p $(DIST_DIR)
	@echo "$(YELLOW)Building for Linux/amd64...$(NC)"
	GOOS=linux GOARCH=amd64 $(GO_BUILD_FLAGS) go build $(LDFLAGS) -o $(DIST_DIR)/$(BINARY_NAME)_linux_amd64 main.go
	@echo "$(YELLOW)Building for Linux/arm64...$(NC)"
	GOOS=linux GOARCH=arm64 $(GO_BUILD_FLAGS) go build $(LDFLAGS) -o $(DIST_DIR)/$(BINARY_NAME)_linux_arm64 main.go
	@echo "$(YELLOW)Building for macOS/amd64...$(NC)"
	GOOS=darwin GOARCH=amd64 $(GO_BUILD_FLAGS) go build $(LDFLAGS) -o $(DIST_DIR)/$(BINARY_NAME)_darwin_amd64 main.go
	@echo "$(YELLOW)Building for macOS/arm64...$(NC)"
	GOOS=darwin GOARCH=arm64 $(GO_BUILD_FLAGS) go build $(LDFLAGS) -o $(DIST_DIR)/$(BINARY_NAME)_darwin_arm64 main.go
	@echo "$(YELLOW)Building for Windows/amd64...$(NC)"
	GOOS=windows GOARCH=amd64 $(GO_BUILD_FLAGS) go build $(LDFLAGS) -o $(DIST_DIR)/$(BINARY_NAME)_windows_amd64.exe main.go
	@echo "$(GREEN)✅ All builds completed in $(DIST_DIR)/$(NC)"

# Install binary
install: build
	@echo "$(BLUE)📦 Installing $(BINARY_NAME) to $(PREFIX)/bin/...$(NC)"
	@install -d $(PREFIX)/bin
	@install -m 755 $(BINARY_NAME) $(PREFIX)/bin/$(BINARY_NAME)
	@echo "$(GREEN)⚓ Anchor installed to $(PREFIX)/bin/$(BINARY_NAME)$(NC)"

# Uninstall binary
uninstall:
	@echo "$(BLUE)🗑️ Removing $(BINARY_NAME) from $(PREFIX)/bin/...$(NC)"
	@rm -f $(PREFIX)/bin/$(BINARY_NAME)
	@echo "$(GREEN)⚓ Anchor removed from $(PREFIX)/bin/$(BINARY_NAME)$(NC)"

# Clean build artifacts
clean:
	@echo "$(BLUE)🧹 Cleaning build artifacts...$(NC)"
	@rm -f $(BINARY_NAME)
	@rm -f *.exe *.test *.out coverage.out
	@rm -rf $(DIST_DIR) $(BIN_DIR)
	@rm -f .anchor_store.json
	@echo "$(GREEN)✅ Clean completed$(NC)"

# Run tests
test:
	@echo "$(BLUE)🧪 Running tests...$(NC)"
	go test -v -race -coverprofile=coverage.out ./...
	@echo "$(GREEN)✅ Tests completed$(NC)"

# Run tests with coverage
test-coverage: test
	@echo "$(BLUE)📊 Generating coverage report...$(NC)"
	go tool cover -html=coverage.out -o coverage.html
	@echo "$(GREEN)✅ Coverage report generated: coverage.html$(NC)"

# Format code
fmt:
	@echo "$(BLUE)🎨 Formatting code...$(NC)"
	go fmt ./...
	@echo "$(GREEN)✅ Code formatted$(NC)"

# Lint code
lint:
	@echo "$(BLUE)🔍 Linting code...$(NC)"
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run; \
	else \
		echo "$(YELLOW)⚠️ golangci-lint not found. Install with: brew install golangci-lint$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✅ Linting completed$(NC)"

# Security scan
security:
	@echo "$(BLUE)🔒 Running security scan...$(NC)"
	@if command -v gosec >/dev/null 2>&1; then \
		gosec ./...; \
	else \
		echo "$(YELLOW)⚠️ gosec not found. Install with: go install github.com/securecodewarrior/gosec/v2/cmd/gosec@latest$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✅ Security scan completed$(NC)"

# Download dependencies
deps:
	@echo "$(BLUE)📦 Downloading dependencies...$(NC)"
	go mod download
	go mod tidy
	@echo "$(GREEN)✅ Dependencies updated$(NC)"

# Development mode with hot reload
dev:
	@echo "$(BLUE)🔥 Starting development mode...$(NC)"
	@if command -v air >/dev/null 2>&1; then \
		air -c .air.toml; \
	else \
		echo "$(YELLOW)⚠️ air not found. Install with: go install github.com/cosmtrek/air@latest$(NC)"; \
		echo "$(YELLOW)🔧 Falling back to manual build with watch...$(NC)"; \
		while true; do \
			make build; \
			echo "$(BLUE)⏱️ Watching for changes... Press Ctrl+C to stop$(NC)"; \
			inotifywait -e modify,create,delete --include '\.go$$' -r . 2>/dev/null || sleep 2; \
		done \
	fi

# Validate GoReleaser configuration
validate-release:
	@echo "$(BLUE)✅ Validating GoReleaser configuration...$(NC)"
	@if command -v goreleaser >/dev/null 2>&1; then \
		goreleaser check; \
	else \
		echo "$(YELLOW)⚠️ goreleaser not found. Install with: go install github.com/goreleaser/goreleaser/v2@latest$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✅ Configuration is valid$(NC)"

# Create a release snapshot
release-snapshot:
	@echo "$(BLUE)📸 Creating release snapshot...$(NC)"
	@if command -v goreleaser >/dev/null 2>&1; then \
		goreleaser release --snapshot --clean; \
	else \
		echo "$(RED)❌ goreleaser not found. Install with: go install github.com/goreleaser/goreleaser/v2@latest$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✅ Release snapshot created$(NC)"

# Setup development environment
setup-dev:
	@echo "$(BLUE)🛠️ Setting up development environment...$(NC)"
	@echo "$(YELLOW)Installing Go tools...$(NC)"
	@go install github.com/cosmtrek/air@latest
	@go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@go install github.com/securecodewarrior/gosec/v2/cmd/gosec@latest
	@go install github.com/goreleaser/goreleaser/v2@latest
	@echo "$(GREEN)✅ Development tools installed$(NC)"
	@echo "$(BLUE)🐋 Installing Ollama (if not present)...$(NC)"
	@if ! command -v ollama >/dev/null 2>&1; then \
		if command -v brew >/dev/null 2>&1; then \
			brew install ollama; \
		else \
			echo "$(YELLOW)⚠️ Please install Ollama manually: https://ollama.ai$(NC)"; \
		fi \
	else \
		echo "$(GREEN)✅ Ollama already installed$(NC)"; \
	fi
	@echo "$(GREEN)🎉 Development environment setup complete!$(NC)"

# Show help
help:
	@echo "$(BLUE)⚓ Anchor CLI Makefile$(NC)"
	@echo ""
	@echo "$(GREEN)Build Targets:$(NC)"
	@echo "  build          Build binary for current platform"
	@echo "  build-all      Build binaries for all platforms"
	@echo "  install        Install binary to $(PREFIX)/bin"
	@echo "  uninstall      Remove binary from $(PREFIX)/bin"
	@echo "  clean          Clean build artifacts"
	@echo ""
	@echo "$(GREEN)Development Targets:$(NC)"
	@echo "  dev            Start development mode with hot reload"
	@echo "  test           Run tests"
	@echo "  test-coverage  Run tests with coverage report"
	@echo "  fmt            Format Go code"
	@echo "  lint           Lint Go code"
	@echo "  security       Run security scan"
	@echo "  deps           Update dependencies"
	@echo "  setup-dev      Install development tools"
	@echo ""
	@echo "$(GREEN)Release Targets:$(NC)"
	@echo "  validate-release Validate GoReleaser configuration"
	@echo "  release-snapshot Create release snapshot"
	@echo ""
	@echo "$(GREEN)Info:$(NC)"
	@echo "  VERSION: $(VERSION)"
	@echo "  BUILD_DATE: $(BUILD_DATE)"
	@echo "  GIT_COMMIT: $(GIT_COMMIT)"
	@echo "  GOOS: $(GOOS)"
	@echo "  GOARCH: $(GOARCH)"

# Check if required commands are available
check-deps:
	@echo "$(BLUE)🔍 Checking dependencies...$(NC)"
	@command -v go >/dev/null 2>&1 || (echo "$(RED)❌ Go is required$(NC)" && exit 1)
	@command -v git >/dev/null 2>&1 || (echo "$(RED)❌ Git is required$(NC)" && exit 1)
	@echo "$(GREEN)✅ Required dependencies are available$(NC)"