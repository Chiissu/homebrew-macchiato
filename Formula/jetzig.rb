class Jetzig < Formula
  desc "A web framework written in Zig"
  homepage "https://www.jetzig.dev"
  license "MIT"
  version "Unknown"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://www.jetzig.dev/build-macos-aarch64.zip"
      sha256 "30ce5c667e7d1d55ed786a8b9b72f2866aacc5a74a6ebda8651383b097ff188a"
    elsif Hardware::CPU.avx2?
      url "https://www.jetzig.dev/build-macos-x86.zip"
      sha256 "95ded9a4d6186860506e0bd77c98c18d71b26c941545201330e00e80ed007715"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    url "https://www.jetzig.dev/build-linux.zip"
    sha256 "9ce7054d9a9436989317f889ecbfa0a7a1a92ecfe1f718480ad9a5f80d060952"
  end

  def install
    bin.install "bin/jetzig"
  end

  test do
    system "#{bin}/jetzig"
  end
end
