class SafeHash < Formula
  desc "Verify Safe Wallet Transactions and Messages"
  homepage "Verify Safe Wallet Transactions and Messages"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.2/safe-hash-aarch64-apple-darwin.tar.xz"
      sha256 "3f6c66dd8f862924f837484556ec5f3c47b57f813a2aed520f37a72a76dda6bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.2/safe-hash-x86_64-apple-darwin.tar.xz"
      sha256 "13d5759b173f936597e023dc6b9b694f28c60cda5442ad4725527b32589dbe40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.2/safe-hash-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e2e23f21acea7525ccb8cc1ada234b1b076f37f37c670428d9598b50b381c690"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.2/safe-hash-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "edad27c0e52b910434a473e2d0611c16ae1b0e798aa0c24728f074f6d6a8c445"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
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
