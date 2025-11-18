class ZlsNightly < Formula
  desc "Language Server for Zig"
  homepage "https://zigtools.org/zls"
  version "0.16.0-dev.40+0221b428"
  license "MIT"

  depends_on "zig-nightly"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://builds.zigtools.org/zls-macos-aarch64-#{version}.tar.xz"
      sha256 "2b69c5c946a355eec03c58350e0aa03cbaaa1615af62c229c7553ffed858b38c"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-macos-x86_64-#{version}.tar.xz"
      sha256 "d36b47ad88f688e9ac3e5128d69dd90f68631a74362a686a95095122f51f76b0"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://builds.zigtools.org/zls-linux-aarch64-#{version}.tar.xz"
      sha256 "8b60646c0cece57c2eddb2096b46ab93f38f216dda266fd2cab0ce7fa7d63e3a"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-linux-x86_64-#{version}.tar.xz"
      sha256 "c85b19a0e6d0b22850de906c7819713f16da3bca8310dfd5b3056a55d290026b"
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
