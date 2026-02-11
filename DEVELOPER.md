# Anchor Developer Notes ⚓

This file contains the internal process for packaging and releasing the `anchor` tool.

## Release Process (Moving to a Standalone Repo)

### 1. Repository Setup
1. Create `github.com/selimbens/anchor`.
2. Push this directory's contents as the root of the new repo.
3. Ensure `go.mod` is set to `module github.com/selimbens/anchor`.

### 2. Versioning & Tags
To create a new release for Homebrew/Go:
```bash
git tag v1.0.0
git push origin v1.0.0
```

### 3. Homebrew Tap Maintenance
If using a Homebrew Tap (`selimbens/homebrew-tap`):

1. **Calculate the SHA256** of the release source:
   ```bash
   curl -L https://github.com/selimbens/anchor/archive/refs/tags/v1.0.0.tar.gz | shasum -a 256
   ```
2. **Update the Formula**:
   Update `Formula/anchor.rb` with the new version and the resulting `sha256` hash.
3. **Push to Tap**:
   Commit and push the updated formula to your `homebrew-tap` repository.

## Future Improvements
- [ ] Add support for `boltDB` or `sqlite-vss` for faster queries on large repos.
- [ ] Implement incremental ingestion (only re-embed changed files).
- [ ] Add a `watch` command to auto-ingest on file saves.
