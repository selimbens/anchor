# Anchor ⚓ - Project Roadmap

This roadmap outlines the planned enhancements and maintenance for the Anchor CLI.

## Phase 1: Performance & Quality (Current)
- [x] **Incremental Ingestion**: Only re-embed changed files.
- [x] **Versioning & Releases**: Systematic versioning with Git tags.
- [ ] **Robust Test Suite**: Mocking Ollama and comprehensive file system tests.
- [ ] **GitHub Actions (CI)**: Automated testing and formatting on every push.

## Phase 2: User Experience & Utility
- [x] **Docker Compose Integration**: Orchestrate `anchor` and `ollama` with persistent volumes.
- [ ] **`anchor doctor`**: A diagnostic command to check system health (Go, Ollama, Models).
- [ ] **Custom Store Path**: Support for a `-store` flag to specify the database file.
- [ ] **Watch Mode**: Real-time re-indexing as files are saved.

## Phase 3: Scaling & Advanced Search
- [ ] **SQLite/Vector Store**: Move from JSON to a more performant local database.
- [ ] **Semantic Filtering**: Filter results by directory or metadata tags.
- [ ] **Codebase Support**: Optimized chunking for source code files.

## Phase 4: Distribution & Outreach
- [ ] **Official Homebrew Tap**: Complete the Homebrew formula for easy installation.
- [ ] **Package Management**: Automated releases for Linux, macOS, and Windows.
- [ ] **Documentation Expansion**: Detailed guides for AI agent integration.

---

### Future Vision
Anchor aims to be the fastest, most authentic local knowledge retrieval tool—grounded in simplicity and zero dependencies. ⚓
