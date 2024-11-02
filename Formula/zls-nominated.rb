class ZlsNominated < Formula
  desc "Language Server for Zig"
  homepage "https://github.com/zigtools/zls"
  version "0.14.0-dev.183+b2e89df"
  license "MIT"

  depends_on "zig-nominated"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://builds.zigtools.org/zls-macos-aarch64-#{version}.tar.xz"
      sha256 "32d74b2dfc57019dfa8ee24fee0d781313413358b59600457ad0c8d44917a686"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-macos-x86_64-#{version}.tar.xz"
      sha256 "cd2a6e6fa153595b4655bc766a2a1709a91dfb9adf2ab25b7da2f65b31a2a82b"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://builds.zigtools.org/zls-linux-aarch64-#{version}.tar.xz"
      sha256 "38c72865f403ba5b4861fda31f3d4f9280233da754d70d54bc30131564d0d676"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-linux-x86_64-#{version}.tar.xz"
      sha256 "a9aedcc06797d3c185f93fb5dd8ff695c4f3e2b2dfac35de137eefdbbaed881a"
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
    <<~EOS
      ⚠️ You have other version of the zls package installed, which conflicts with this nominated version.
      To switch to the nominated version, run:
      $ brew link --overwrite zls-nominated
      To switch back to the official or nightly version, run:
      $ brew link --overwrite zls
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
