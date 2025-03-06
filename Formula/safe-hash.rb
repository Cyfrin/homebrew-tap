class SafeHash < Formula
  desc "Verify Safe Wallet Transactions and Messages"
  homepage "Verify Safe Wallet Transactions and Messages"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.1/safe-hash-aarch64-apple-darwin.tar.xz"
      sha256 "87aa0638b7303e46e972324a9affc07acae8fc79e855ce9e61bac4126821da0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.1/safe-hash-x86_64-apple-darwin.tar.xz"
      sha256 "bd727a0703e0f179164e35a845ca93753bbca4321bf462ad28de61dd26f58e22"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.1/safe-hash-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7fdd8be0e58d2b2d8ea4db652492ce96c2107e01cbe1cdb76b9c83b4adb0e3c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Cyfrin/safe-hash-rs/releases/download/safe-hash-v0.0.1/safe-hash-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0103f54910646f22b6ba34162de83332bde22fc3db4bc543c5043a923398afb2"
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
