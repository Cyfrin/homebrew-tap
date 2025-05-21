class SafeHash < Formula
  desc "Verify Safe Wallet Transactions and Messages"
  homepage "Verify Safe Wallet Transactions and Messages"
  version "0.0.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.17/safe-hash-aarch64-apple-darwin.tar.xz"
      sha256 "10848ff52452bcc95a7fd826e93eb038c99d655ee27fa99a0d8d10bea139aab5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.17/safe-hash-x86_64-apple-darwin.tar.xz"
      sha256 "c34e0e33c011874732ef9b534cf2822a930b740cc302284a5549240e2e7586be"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.17/safe-hash-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ad93557f1aeb7ed852c6f41e667a383f204977b7de2b224c58c2b912d5b4a6e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.17/safe-hash-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c319415e70ab3671d8b185c55a630e54b262490def58f53583ba1b97a69e7b6"
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
