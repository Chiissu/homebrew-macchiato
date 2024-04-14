class Jetzig < Formula
  desc "A web framework written in Zig"
  homepage "https://www.jetzig.dev"
  license "MIT"
  version "25587d4"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://www.jetzig.dev/build-macos-aarch64.zip"
      sha256 "eeba0abfb0fa55ef33dcc36b67b66e3dc18c2cbf6f2c55245f1be185ec7d3ce7"
    elsif Hardware::CPU.avx2?
      url "https://www.jetzig.dev/build-macos-x86.zip"
      sha256 "4d7b28b796eff63baafcbe98af8521a3997a297b1139a8cd5f97c9783b8160aa"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    url "https://www.jetzig.dev/build-linux.zip"
    sha256 "8565a5df97afc1eebc62ea2e86861f9580f54dced071bc1cf0cf3b5ab82feb85"
  end

  def install
    bin.install "bin/jetzig"
  end

  test do
    system "#{bin}/jetzig"
  end
end
