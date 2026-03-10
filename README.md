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
anchor ask "What is the symbolic link between the whale's deep silence and my philosophy on 'staying underwater' (and my visceral hatred of unread emails)?"
```

## Installation & Uninstallation

### 1. The "Go Native Way" (Recommended for Developers)
If your `$GOPATH/bin` is in your `$PATH`:

**Install from GitHub:**
```bash
go install github.com/selimbens/anchor@latest
```

**Install from Local Source:**
```bash
go install -ldflags "-X github.com/selimbens/anchor/cmd/version.Version=$(git describe --tags --always) -s -w" .
```

**Update:**
To update to the latest version, simply re-run the installation command from the repository root.

**Uninstall:**
```bash
rm $(go env GOPATH)/bin/anchor
```

---

### 2. Pre-built Binaries (GitHub Releases)
For most users, you can find the latest pre-compiled binaries for your platform (Linux, macOS, Windows) on the **[Releases](https://github.com/selimbens/anchor/releases)** page. Simply download the archive for your architecture, extract it, and move the `anchor` binary to your `/usr/local/bin/` or any directory in your `$PATH`.

---

### 3. The "Makefile" Way (Manual/Global Control)
**Install:**
```bash
make install
```

**Uninstall:**
```bash
make uninstall
```

---

### 4. The "Docker Way" (Containerized/Isolated)
If you prefer to run Anchor in an isolated environment with its own Ollama instance:

**Run with Docker Compose:**
```bash
docker-compose up -d
```
This starts both Anchor and a dedicated Ollama container. Place your notes in a `notes/` directory in the project root for automatic ingestion.

## AI Agent Integration

To enable an AI agent (like Gemini CLI or Cursor) to use Anchor for local knowledge retrieval, add the following to its system prompt or project context (e.g., `.gemini/GEMINI.md`):

```markdown
### ⚓ Anchor Integration
You have access to the `anchor` CLI tool for local knowledge retrieval.
- **Goal**: Before providing advice on principles, past decisions, or career strategy, check the local knowledge base.
- **Usage**: 
  - Run `anchor ask "<question>"` to retrieve relevant context.
  - If the knowledge base is missing, suggest running `anchor ingest <dir>`.
- **Constraint**: Ollama must be running locally with the `nomic-embed-text` model for this to work.
```

## Setup Requirements
- **Go**: Required for building from source.
- **Ollama**: Must be running locally.
- **Model**: `nomic-embed-text` must be pulled (`ollama pull nomic-embed-text`).

## Development Setup
- Use `make build` to create the binary.
- Use `make test` to run unit tests.
- Use `go install .` for local global installation.

## Next Steps (Sovereignty Path)
- [x] **Enhanced .gitignore**: Comprehensive patterns for modern Go development
- [x] **Development Infrastructure**: Makefile, testing, and basic CLI
- [ ] **Homebrew Integration**: Official tap for easier macOS installation.
- [x] **Performance Optimization**: Incremental ingestion to only re-embed changed files.
- [ ] **Automated Ingest**: Add a git hook or cron job to re-ingest your notes daily.
- [ ] **Advanced Search**: Add semantic search capabilities and filtering.
