class Jetzig < Formula
  desc "A web framework written in Zig"
  homepage "https://www.jetzig.dev"
  license "MIT"
  version "31e8ae3"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://www.jetzig.dev/build-macos-aarch64.zip"
      sha256 "0947e4e64f33b23988ca7136e89c65a6c48832a21e4c4d7d838a42bf3f6cb25f"
    elsif Hardware::CPU.avx2?
      url "https://www.jetzig.dev/build-macos-x86.zip"
      sha256 "4fc19f7ca33ef96db3fcf0e28035e3eb0861aea909d6d4f7d381403eb3968bae"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    url "https://www.jetzig.dev/build-linux.zip"
    sha256 "7e4f296b2d6cde4b5b3b883f43e66b46e13398be4fbabba594e48b0c9ab2b6c4"
  end

  def install
    bin.install "bin/jetzig"
  end

  test do
    system "#{bin}/jetzig"
  end
end
