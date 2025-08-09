class ZlsNightly < Formula
  desc "Language Server for Zig"
  homepage "https://zigtools.org/zls"
  version "0.15.0-dev.348+b00ed99c"
  license "MIT"

  depends_on "zig-nightly"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://builds.zigtools.org/zls-macos-aarch64-#{version}.tar.xz"
      sha256 "000da0cdd889e96f8004e778b4d8532f5f4afa7b62adefd1e528608d9957e12c"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-macos-x86_64-#{version}.tar.xz"
      sha256 "a1e861d335097db2753e44cf41e75ebc504eec98b7d8c73a033eeb1da6b4fce8"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://builds.zigtools.org/zls-linux-aarch64-#{version}.tar.xz"
      sha256 "4ba9be0bda2ec724b5154cc77bf3474ea1cb009310abc8c87c6533778da2c8ad"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-linux-x86_64-#{version}.tar.xz"
      sha256 "ee02ccf4bf0a46af0643fcba1c943df8e35b47cf1db86c4732a11cdfa01ce27a"
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
