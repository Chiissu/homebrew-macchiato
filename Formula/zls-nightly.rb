class ZlsNightly < Formula
  desc "Language Server for Zig"
  homepage "https://zigtools.org/zls"
  version "0.16.0-dev.42+1e267a7b"
  license "MIT"

  depends_on "zig-nightly"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://builds.zigtools.org/zls-macos-aarch64-#{version}.tar.xz"
      sha256 "b7cf59abf63d99df79cc943ef49deea4f0ec537e8a6eedb550ef147603940ef9"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-macos-x86_64-#{version}.tar.xz"
      sha256 "9e535cdff05b5c422322e4de1f6c9e4fb302157bd7b91beb2eacb1020931c6f0"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://builds.zigtools.org/zls-linux-aarch64-#{version}.tar.xz"
      sha256 "52b1860c4613cc54715417aa01d3060373863ce17377129291303ebd52cef81e"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-linux-x86_64-#{version}.tar.xz"
      sha256 "1a415165fd6cad8a5ee2d1984aa5f388c994f371ea5bcd3350074b9efcef7098"
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
