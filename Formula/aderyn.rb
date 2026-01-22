class Aderyn < Formula
  desc "Rust based Solidity AST analyzer backend"
  homepage "https://github.com/cyfrin/aderyn"
  version "0.6.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.8/aderyn-aarch64-apple-darwin.tar.xz"
      sha256 "624c6652bb9478b38ddc255c27819cd5c6cb0448f5deb72036cc9cf5a27d4aac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.8/aderyn-x86_64-apple-darwin.tar.xz"
      sha256 "c2ef361c6b2e24c20d478e6cb30cc427090f29c3501adb7190cb514623ce6d8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.8/aderyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "961070bf5ee4ed0f82f67a261c616e1525ec1b036bae60cdaec94d087eb5e405"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.6.8/aderyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ffd6ca658962e211a3ac821c646f69c8e14bf1b1001cbfe091bcd4535a691e46"
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
