class Aderyn < Formula
  desc "Rust based Solidity AST analyzer"
  homepage "https://github.com/cyfrin/aderyn"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.5.3/aderyn-aarch64-apple-darwin.tar.xz"
      sha256 "47d92269e1da352271da0c77682e816cacbec527044442321229335f98947a3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.5.3/aderyn-x86_64-apple-darwin.tar.xz"
      sha256 "7789c7b443a0aaaa8e811c93bb395fe8d008f5141e2a969dd0564b186bd13d47"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.5.3/aderyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "37b7edd8d2cef5bfcdd3835a5cdd60483f9d2505c6ef1d5dd7f5e66764c83149"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.5.3/aderyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "28f1a344ad48415d4f18ad8bae7aa2c0762cb45ba03b8942b608ad131e86298e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
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
