class Jetzig < Formula
  desc "A web framework written in Zig"
  homepage "https://www.jetzig.dev"
  license "MIT"
  version "0.0.0-1cb27ff"

  depends_on "zig-nightly"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://jetzig.dev/downloads/build-macos-aarch64.zip"
      sha256 "80ee5548d56cd6f46b2a225168ec57092a9f54d0e7169b56b0a110f1ac96a98c"
    elsif Hardware::CPU.avx2?
      url "https://jetzig.dev/downloads/build-macos-x86.zip"
      sha256 "dacf8662ded34294916acf19c605c4bf6b0fb689131307ca72a9cbbb6cf89841"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    url "https://jetzig.dev/downloads/build-linux.zip"
    sha256 "211b53fc3da6c79e7720a09b6a459b7d56cc4d8484517f0eb92a216b4a455796"
  end

  def install
    bin.install "bin/jetzig"
  end

  test do
    system "#{bin}/jetzig"
  end
end
