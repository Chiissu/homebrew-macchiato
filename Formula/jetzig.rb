class Jetzig < Formula
  desc "A web framework written in Zig"
  homepage "https://www.jetzig.dev"
  license "MIT"
  version "940bc27"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://www.jetzig.dev/build-macos-aarch64.zip"
      sha256 "d98bde08329043afc092595d7c1aa7db62e96b6fa3c81a3ad193018b95565611"
    elsif Hardware::CPU.avx2?
      url "https://www.jetzig.dev/build-macos-x86.zip"
      sha256 "9eead2a99ce558b1c6c16bc504063d33ceb2fcf8490fc6d8e9ccd52a60f6405b"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    url "https://www.jetzig.dev/build-linux.zip"
    sha256 "944a6f3ab62779c458ef1dd1c9ebfe9ba58b09d43ec91c8177b0cacd92a54eb0"
  end

  def install
    bin.install "bin/jetzig"
  end

  test do
    system "#{bin}/jetzig"
  end
end
