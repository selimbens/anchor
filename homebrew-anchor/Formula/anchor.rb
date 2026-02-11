# Anchor < Formula
class Anchor < Formula
  desc "AI-powered CLI tool for local LLM knowledge retrieval via Ollama"
  homepage "https://github.com/selimbens/anchor"
  url "https://github.com/selimbens/anchor/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "temp_sha256_placeholder"
  license "MIT"
  head "https://github.com/selimbens/anchor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bottle_placeholder_arm64_sequoia"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bottle_placeholder_arm64_sonoma"
    sha256 cellar: :any_skip_relocation, sonoma:         "bottle_placeholder_amd64_sonoma"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bottle_placeholder_amd64_linux"
  end

  depends_on "go" => :build

  def install
    ldflags = [
      "-s",
      "-w",
      "-X",
      "github.com/selimbens/anchor/internal/version.Version=#{version}",
      "-X",
      "github.com/selimbens/anchor/internal/version.GitCommit=#{tap.user}",
      "-X",
      "github.com/selimbens/anchor/internal/version.BuildDate=#{Time.now.iso8601}"
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"anchor"

    # Generate shell completions if available in future versions
    # generate_completions_from_executable(bin/"anchor", shell_parameter_format: :flag)
  end

  test do
    assert_match "anchor", shell_output("#{bin}/anchor --help 2>&1")
    assert_match "Usage:", shell_output("#{bin}/anchor --help 2>&1")
  end

  def caveats
    <<~EOS
      Anchor requires Ollama to be installed and running locally.
      
      🚀 Quick Start:
      
      1. Install Ollama:
         brew install ollama
      
      2. Start Ollama service:
         brew services start ollama
         # Or run manually: ollama serve
      
      3. Pull the required embedding model:
         ollama pull nomic-embed-text
      
      4. Optional: Pull a chat model for enhanced functionality:
         ollama pull llama2
         ollama pull mistral
      
      🔧 Verification:
      - Check Ollama status: curl http://localhost:11434/api/tags
      - Test Anchor: anchor ingest /path/to/your/notes
      
      📚 Documentation:
      For more information, visit: https://github.com/selimbens/anchor
      
      🐛 Troubleshooting:
      - If Ollama connection fails, ensure Ollama is running on localhost:11434
      - Check Ollama logs: brew services log ollama
      - Verify model installation: ollama list
    EOS
  end
end