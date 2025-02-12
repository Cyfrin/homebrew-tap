class Aderyn < Formula
  desc "Rust based Solidity AST analyzer"
  homepage "https://github.com/cyfrin/aderyn"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.4.0/aderyn-aarch64-apple-darwin.tar.xz"
      sha256 "afd0dbfe6f3a6410c69f6cd524823fe3966e33a4993fe89c89e36ddf3abfcef4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.4.0/aderyn-x86_64-apple-darwin.tar.xz"
      sha256 "0ec60c9f78eb276940d8020e8f0694325242ddb08be611dcffcb7ca0d6eed318"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.4.0/aderyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "34d96e6d5fbe8f74c87648e4366cba014a9ba6df4046cd31ca7e229ceae68a80"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.4.0/aderyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1cdb423e899c115e01136d8679144ce2418de51a26d67e3bc0c95b0dfc6b624d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "aderyn" if OS.mac? && Hardware::CPU.arm?
    bin.install "aderyn" if OS.mac? && Hardware::CPU.intel?
    bin.install "aderyn" if OS.linux? && Hardware::CPU.arm?
    bin.install "aderyn" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
