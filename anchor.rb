class Anchor < Formula
  desc "A lightweight, zero-dependency CLI tool for personal knowledge retrieval"
  homepage "https://github.com/selimbens/anchor"
  url "https://github.com/selimbens/anchor/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256" # Run `curl -L <url> | shasum -a 256` to get this
  license "MIT"

  depends_on "go" => :build

  def install
    # This builds the binary and installs it into the Homebrew bin directory
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Simple test to ensure the binary runs
    assert_match "Usage: anchor", shell_output("#{bin}/anchor 2>&1")
  end
end
