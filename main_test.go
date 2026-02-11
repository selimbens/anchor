package main

import (
	"os"
	"testing"

	"github.com/selimbens/anchor/cmd/version"
)

func TestVersionInfo(t *testing.T) {
	info := version.Info()
	if info == "" {
		t.Error("Expected version info to not be empty")
	}

	if !contains(info, "anchor") {
		t.Errorf("Expected version info to contain 'anchor', got: %s", info)
	}
}

func TestApplicationConstants(t *testing.T) {
	// Test that constants are properly defined
	if storePath != ".anchor_store.json" {
		t.Errorf("Expected storePath to be '.anchor_store.json', got: %s", storePath)
	}
}

func TestBasicFunctions(t *testing.T) {
	// Test truncate function
	short := "short"
	if truncate(short, 10) != short {
		t.Error("Expected short text to remain unchanged")
	}

	long := "this is a very long text that should be truncated"
	result := truncate(long, 10)
	expected := "this is a ..."
	if result != expected {
		t.Errorf("Expected truncated text to be %s, got: %s", expected, result)
	}

	// Test cosine similarity
	v1 := []float64{1.0, 0.0, 0.0}
	v2 := []float64{1.0, 0.0, 0.0}
	score := cosineSimilarity(v1, v2)
	if score != 1.0 {
		t.Errorf("Expected cosine similarity of 1.0 for identical vectors, got: %f", score)
	}
}

func TestFileHandling(t *testing.T) {
	// Test basic file operations
	tempDir, err := os.MkdirTemp("", "anchor_test")
	if err != nil {
		t.Fatalf("Error creating temp dir: %v", err)
	}
	defer os.RemoveAll(tempDir)

	// Create a test markdown file
	testFile := tempDir + "/test.md"
	content := "# Test Note\n\nThis is a test note for testing."
	err = os.WriteFile(testFile, []byte(content), 0644)
	if err != nil {
		t.Errorf("Error creating test file: %v", err)
	}

	// Verify file exists
	if _, err := os.Stat(testFile); os.IsNotExist(err) {
		t.Error("Test file should exist")
	}
}

// Helper functions
func contains(s, substr string) bool {
	for i := 0; i <= len(s)-len(substr); i++ {
		if s[i:i+len(substr)] == substr {
			return true
		}
	}
	return false
}
