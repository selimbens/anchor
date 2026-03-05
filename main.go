package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"math"
	"net/http"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/selimbens/anchor/cmd/version"
)

type Anchor struct {
	Path      string    `json:"path"`
	Content   string    `json:"content"`
	Embedding []float64 `json:"embedding"`
}

type VectorStore struct {
	Anchors []Anchor `json:"anchors"`
}

type EmbeddingResponse struct {
	Embedding []float64 `json:"embedding"`
}

type EmbeddingRequest struct {
	Model  string `json:"model"`
	Prompt string `json:"prompt"`
}

const storePath = ".anchor_store.json"

func main() {
	// Parse flags
	versionFlag := flag.Bool("version", false, "Show version information")
	flag.Parse()

	// Handle version flag
	if *versionFlag {
		fmt.Print(version.Info())
		return
	}

	// Check for commands
	args := flag.Args()
	if len(args) < 1 {
		fmt.Println("Usage: anchor [flags] <command> [args]")
		fmt.Println("Commands: ingest, ask")
		fmt.Println("\nFlags:")
		flag.PrintDefaults()
		os.Exit(1)
	}

	command := args[0]

	switch command {
	case "ingest":
		if len(args) < 2 {
			fmt.Println("Usage: anchor ingest <directory>")
			os.Exit(1)
		}
		path := args[1]
		err := ingest(path)
		if err != nil {
			fmt.Printf("Error during ingest: %v\n", err)
		}
	case "ask":
		if len(args) < 2 {
			fmt.Println("Usage: anchor ask \"<question>\"")
			os.Exit(1)
		}
		query := args[1]
		err := ask(query)
		if err != nil {
			fmt.Printf("Error during search: %v\n", err)
		}
	case "help", "--help", "-h":
		fmt.Printf(`Anchor - AI-powered CLI tool for local LLM knowledge retrieval

USAGE:
    anchor [flags] <command> [args]

COMMANDS:
    ingest <directory>    Index markdown files in directory
    ask "<question>"       Query your knowledge base
    help                  Show this help message
    version               Show version information

FLAGS:
    -version              Show version information

EXAMPLES:
    anchor ingest ~/Documents/notes
    anchor ask "What is the symbolic link between the whale's deep silence and my philosophy on 'staying underwater' (and my visceral hatred of unread emails)?"

PREREQUISITES:
    - Ollama must be installed and running locally
    - Run: ollama pull nomic-embed-text

For more information, visit: https://github.com/selimbens/anchor
`)
		os.Exit(0)
	default:
		fmt.Printf("Unknown command: %s\n", command)
	}
}

func ingest(root string) error {
	var store VectorStore

	err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		// Skip hidden directories and node_modules, but don't skip the root itself
		if info.IsDir() && path != root && (strings.HasPrefix(info.Name(), ".") || info.Name() == "node_modules") {
			return filepath.SkipDir
		}
		if !info.IsDir() && strings.HasSuffix(info.Name(), ".md") {
			fmt.Printf("⚓ Anchoring %s...\n", path)
			content, err := os.ReadFile(path)
			if err != nil {
				return err
			}

			// Robust chunking: split by any '##' but keep the first part
			parts := strings.Split(string(content), "##")
			for _, part := range parts {
				text := strings.TrimSpace(part)
				if len(text) < 20 {
					continue
				}

				emb, err := getEmbedding(text)
				if err != nil {
					return fmt.Errorf("failed to get embedding for %s: %w", path, err)
				}

				store.Anchors = append(store.Anchors, Anchor{
					Path:      path,
					Content:   text,
					Embedding: emb,
				})
			}
		}
		return nil
	})

	if err != nil {
		return err
	}

	data, _ := json.MarshalIndent(store, "", "  ")
	return os.WriteFile(storePath, data, 0644)
}

func ask(query string) error {
	data, err := os.ReadFile(storePath)
	if err != nil {
		return fmt.Errorf("knowledge base not found. Run 'ingest' first: %w", err)
	}

	var store VectorStore
	err = json.Unmarshal(data, &store)
	if err != nil {
		return err
	}

	queryEmb, err := getEmbedding(query)
	if err != nil {
		return err
	}

	type Result struct {
		Anchor Anchor
		Score  float64
	}

	var results []Result
	for _, a := range store.Anchors {
		score := cosineSimilarity(queryEmb, a.Embedding)
		results = append(results, Result{Anchor: a, Score: score})
	}

	sort.Slice(results, func(i, j int) bool {
		return results[i].Score > results[j].Score
	})

	fmt.Printf("\n--- Top Anchors for: \"%s\" ---\n\n", query)
	for i := 0; i < 3 && i < len(results); i++ {
		res := results[i]
		fmt.Printf("[%d] Similarity: %.4f | Source: %s\n", i+1, res.Score, res.Anchor.Path)
		fmt.Printf("%s\n\n", truncate(res.Anchor.Content, 500))
	}

	return nil
}

func getEmbedding(text string) ([]float64, error) {
	reqBody := EmbeddingRequest{
		Model:  "nomic-embed-text",
		Prompt: text,
	}
	jsonData, _ := json.Marshal(reqBody)

	resp, err := http.Post("http://localhost:11434/api/embeddings", "application/json", bytes.NewBuffer(jsonData))
	if err != nil {
		return nil, fmt.Errorf("Ollama connection failed (is it running?): %w", err)
	}
	defer resp.Body.Close()

	var embedResp EmbeddingResponse
	err = json.NewDecoder(resp.Body).Decode(&embedResp)
	if err != nil {
		return nil, fmt.Errorf("failed to decode response: %w", err)
	}

	return embedResp.Embedding, nil
}

func cosineSimilarity(v1, v2 []float64) float64 {
	var dotProduct, mag1, mag2 float64
	for i := 0; i < len(v1); i++ {
		dotProduct += v1[i] * v2[i]
		mag1 += v1[i] * v1[i]
		mag2 += v2[i] * v2[i]
	}
	if mag1 == 0 || mag2 == 0 {
		return 0
	}
	return dotProduct / (math.Sqrt(mag1) * math.Sqrt(mag2))
}

func truncate(s string, max int) string {
	if len(s) <= max {
		return s
	}
	return s[:max] + "..."
}
