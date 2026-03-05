# Anchor Developer Notes ⚓

This file contains the internal process for developing and managing the `anchor` tool.

## Development Workflow

### 1. Build & Test
Use the provided `Makefile` for standard tasks:
```bash
make build   # Build binary
make test    # Run tests
make fmt     # Format code
```

### 2. Versioning
This project uses Git tags for versioning. The version is injected at build time using ldflags.

To mark a new state:
```bash
git tag v0.1.0-alpha
```

## Future Improvements
- [ ] Add support for `boltDB` or `sqlite-vss` for faster queries on large repos.
- [ ] Implement incremental ingestion (only re-embed changed files).
- [ ] Add a `watch` command to auto-ingest on file saves.
