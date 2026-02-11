#!/bin/bash
# Test script for local Homebrew formula testing

set -e

echo "🧪 Testing Homebrew formula locally..."

# Create a temporary directory for testing
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Clone the anchor repository to get the source
echo "📦 Cloning anchor repository..."
git clone https://github.com/selimbens/anchor.git anchor-repo
cd anchor-repo

# Build the formula locally
echo "🔨 Building anchor from formula..."
brew install --build-from-source ../Formula/anchor.rb

# Test the installation
echo "✅ Testing anchor installation..."
which anchor
anchor --help

# Test basic functionality
echo "🔍 Testing basic functionality..."
anchor ingest --help || echo "Note: ingest command not yet implemented"
anchor ask --help || echo "Note: ask command not yet implemented"

echo "✅ Homebrew formula test completed successfully!"

# Cleanup
cd /
rm -rf "$TEMP_DIR"
echo "🧹 Cleanup completed"