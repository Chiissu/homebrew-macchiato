class ZlsNightly < Formula
  desc "Language Server for Zig"
  homepage "https://zigtools.org/zls"
  version "0.15.0-dev.344+4aaafc2b"
  license "MIT"

  depends_on "zig-nightly"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://builds.zigtools.org/zls-macos-aarch64-#{version}.tar.xz"
      sha256 "8146e65902a79429991d7f8f6d84b43ca55b5db4182e0f8aa0ec116f3f6f28a7"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-macos-x86_64-#{version}.tar.xz"
      sha256 "3d01791b8906c4b6677176c0fe0bcfc924de6ff22156e65682be422a90e2380a"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://builds.zigtools.org/zls-linux-aarch64-#{version}.tar.xz"
      sha256 "bdaeb66fa5ffbf7d7d3caaaa1b3610a29090c088b23845dbb90406e6206ca3c1"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-linux-x86_64-#{version}.tar.xz"
      sha256 "bcb7b07a60361f1b380a70343badba35c160b6e8d95a48e184a6217f6a31cf00"
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
