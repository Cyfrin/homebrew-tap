class Aderyn < Formula
  desc "Rust based Solidity AST analyzer backend"
  homepage "https://github.com/cyfrin/aderyn"
  version "0.6.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.3/aderyn-aarch64-apple-darwin.tar.xz"
      sha256 "066dfe643064876839e1ab3d42d8ac2a9a40c886576b4a86d861b1f4923447a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.3/aderyn-x86_64-apple-darwin.tar.xz"
      sha256 "94a62125634d2d0256ca99e85ca7784aae7260161e950b46b701bd09d616a2a9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.3/aderyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c6bb734e1342aee90b6a20d61085e26f1862d1b6870e73d0e14b4dbd93ee2392"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.3/aderyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "67a661edc1ec31fda5f65800cf25657b9c98633fea14f132540c6e3f75960173"
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
