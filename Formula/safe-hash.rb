class SafeHash < Formula
  desc "Verify Safe Wallet Transactions and Messages"
  homepage "Verify Safe Wallet Transactions and Messages"
  version "0.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.13/safe-hash-aarch64-apple-darwin.tar.xz"
      sha256 "8dd599a8e749dfcd619d4662adeb513d9f889a023279eb670dfcf713788289c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.13/safe-hash-x86_64-apple-darwin.tar.xz"
      sha256 "bfcfcb0b31a4dc20f7fb9825c58046cd448da6102f792be8943c63b7784a610d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.13/safe-hash-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8336348d7768e2a3839281e8cfa8c30153cb92058b78f992961fbe380fdd5b5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.13/safe-hash-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "50ce4ee5cd8332bf0b2ce01211aa6eb8ab98298f57059fb2a5da6e0aee2516ef"
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
