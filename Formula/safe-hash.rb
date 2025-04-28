class SafeHash < Formula
  desc "Verify Safe Wallet Transactions and Messages"
  homepage "Verify Safe Wallet Transactions and Messages"
  version "0.0.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.10/safe-hash-aarch64-apple-darwin.tar.xz"
      sha256 "d39f77dd20698028d2298578ce72d848a00b144f4aa974a9dafa2e0c7841e0f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.10/safe-hash-x86_64-apple-darwin.tar.xz"
      sha256 "5734c53f7bcc06b0d4c716e12e36b866998e73f038cca48e2421af15b5e9f37d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.10/safe-hash-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f1b9f5d6dc332d010cabf82cfba28d48df536c36a95306eeedda3cf7fed289f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.10/safe-hash-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c8d32884abc598684cdb142ae9df1ead4ac515630d0eab636a22fd86961308d"
    end
  end

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
    bin.install "safe-hash" if OS.mac? && Hardware::CPU.arm?
    bin.install "safe-hash" if OS.mac? && Hardware::CPU.intel?
    bin.install "safe-hash" if OS.linux? && Hardware::CPU.arm?
    bin.install "safe-hash" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
