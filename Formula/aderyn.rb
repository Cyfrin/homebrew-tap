class Aderyn < Formula
  desc "Rust based Solidity AST analyzer backend"
  homepage "https://github.com/cyfrin/aderyn"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.2/aderyn-aarch64-apple-darwin.tar.xz"
      sha256 "eaf95e06195e9b70fa82ce7d7061f62083b093e443bd8b9861485332cac1f99a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.2/aderyn-x86_64-apple-darwin.tar.xz"
      sha256 "1bd77387b2eb275bc1d878c02460ff746b69bb3d9f50b11e5344b5681a160817"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.2/aderyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "814af26327211f8ce6d0c271b66350d0ea7c46037a6b9f3a67b736b72820eac5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.2/aderyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ff35e18d7415c485fedba7708a5209093b50d21927f73e070b230a078fab8052"
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
