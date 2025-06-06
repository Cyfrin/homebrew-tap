class Aderyn < Formula
  desc "Rust based Solidity AST analyzer"
  homepage "https://github.com/cyfrin/aderyn"
  version "0.5.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.5.13/aderyn-aarch64-apple-darwin.tar.xz"
      sha256 "4f46f34e77b6859086067b158f745fe7cb9d305e86d81b1fe8ebc6c6f6449b10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.5.13/aderyn-x86_64-apple-darwin.tar.xz"
      sha256 "b058ce5a13ea3c4619532c41c1a6d197027dfcf1cc9318f600c8299c3d894260"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.5.13/aderyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f3a1c52ff293170f9503d47fe8124a4ec84051b8e4a049bdc87326ed15d3ca16"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.5.13/aderyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a85c5067e10c29290907799e6937d93f01dc2dfb82bf980cd61aebd33ffa6ab"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
