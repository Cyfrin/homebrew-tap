class Aderyn < Formula
  desc "Rust based Solidity AST analyzer backend"
  homepage "https://github.com/cyfrin/aderyn"
  version "0.6.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.4/aderyn-aarch64-apple-darwin.tar.xz"
      sha256 "b3032282c6cfc9a4ff3665acace7fbaaf83352e62b672376826b58e2081b98d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.4/aderyn-x86_64-apple-darwin.tar.xz"
      sha256 "dfdc25a163134b506def44d659efc427bd02a39b6d58be817f8778f1ce703af4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.4/aderyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a56a5ee9e7b40ffe17113eef439f8212185cf9f57928e26e7a11db353188697b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.4/aderyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e5155b6f4e14c92eac601bb7fa82cf93de85c73eff06b075342530ecb597bc58"
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
