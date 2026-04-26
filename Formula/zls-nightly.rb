class ZlsNightly < Formula
  desc "Language Server for Zig"
  homepage "https://zigtools.org/zls"
  version "0.17.0-dev.11+b9eb9c41"
  license "MIT"

  depends_on "zig-nightly"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://builds.zigtools.org/zls-macos-aarch64-#{version}.tar.xz"
      sha256 "567822fd0bba4e35e9e53fc9b83a7b4e46cef78a0b9d2e957fa901ae1d17d07d"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-macos-x86_64-#{version}.tar.xz"
      sha256 "76698b5dcb2a3551d539eb11a4f5b95163873d33eef6956a381d8b16cb15e1a3"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://builds.zigtools.org/zls-linux-aarch64-#{version}.tar.xz"
      sha256 "d6f615f689c80bac94cc7300fc71e52fff6e577ce322afe8da808b38ca784ac2"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-linux-x86_64-#{version}.tar.xz"
      sha256 "c4ef228f9919fd3b332f800b04080680b5a10f1c8e29e6ca0a3593b2b4c06cd7"
    else
      odie "Unsupported Linux architecture."
    end
  else
    odie "Unsupported platform."
  end

  def install
    bin.install "zls"
  end

  def caveats
    return unless Formula["zls"].any_version_installed?
    return unless Formula["zls-nominated"].any_version_installed?
    <<~EOS
      ⚠️ You have other version of the zls package installed, which could conflicts with this version.
      To use this nightly version, run:
      $ brew link --overwrite zls-nightly
      Then restart your language server.
    EOS
  end

  test do
    test_config = testpath/"zls.json"
    test_config.write <<~EOS
      {
        "enable_semantic_tokens": true
      }
    EOS

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/zls --config-path #{test_config}", input, 1)
    assert_match(/^Content-Length: \d+/i, output)

    assert_match version.to_s, shell_output("#{bin}/zls --version")
  end
end
