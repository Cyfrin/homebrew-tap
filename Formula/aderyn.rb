class Aderyn < Formula
  desc "Rust based Solidity AST analyzer"
  homepage "https://github.com/cyfrin/aderyn"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.4.2/aderyn-aarch64-apple-darwin.tar.xz"
      sha256 "6a7951be4042e5f31f61cda7130cbc7518a68683d3f55285e96a40b26a74e457"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.4.2/aderyn-x86_64-apple-darwin.tar.xz"
      sha256 "8771bd7fe15c9c54d8953dd588d0ddad194b9f703071b97462c2da01e3ad3f2e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.4.2/aderyn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "644509656f9aa6262421378e4493c0866533f289694913c6bb66fed577735b47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cyfrin/aderyn/releases/download/aderyn-v0.4.2/aderyn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "def05286ffaa72c2532a7af69655832c4b98ba24b0cbe0d3a254ff7b49e08603"
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
