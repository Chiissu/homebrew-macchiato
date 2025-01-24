class ZlsNominated < Formula
  desc "Language Server for Zig"
  homepage "https://github.com/zigtools/zls"
  version "0.14.0-dev.358+9fc45ca"
  license "MIT"

  depends_on "zig-nominated"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://builds.zigtools.org/zls-macos-aarch64-#{version}.tar.xz"
      sha256 "40f1a6ef0bc351735451b7044cf9e6eeb5c6501127093940415cd82c5d44b5dd"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-macos-x86_64-#{version}.tar.xz"
      sha256 "c3115454e6f23193210c19ff826351f4d33a714a53cd4e38b1cddd6cd24f769c"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://builds.zigtools.org/zls-linux-aarch64-#{version}.tar.xz"
      sha256 "84d027e469a2adea2dfcced8e9807189fe6dee69f4c4d3438e102cae748d370d"
    elsif Hardware::CPU.avx2?
      url "https://builds.zigtools.org/zls-linux-x86_64-#{version}.tar.xz"
      sha256 "ebc69db0fd4084ac66f1680c907d694b6f72af24f7c6a698da3bbcdae7254919"
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
