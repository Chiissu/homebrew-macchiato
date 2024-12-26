class Jetzig < Formula
  desc "A web framework written in Zig"
  homepage "https://www.jetzig.dev"
  license "MIT"
  version "0.1.0-5ebb60d"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://www.jetzig.dev/build-macos-aarch64.zip"
      sha256 "6c61a3d1c88b4d6dcd6e610950baec4e6fb682b200faa38b7dd26cd712b2c03e"
    elsif Hardware::CPU.avx2?
      url "https://www.jetzig.dev/build-macos-x86.zip"
      sha256 "fb1e93451827b51db702aa485c8857a2ebfc6ec58201162eaff75fb9f1379165"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    url "https://www.jetzig.dev/build-linux.zip"
    sha256 "60a551035d5100d234e7f45178f46c3feef4674c8489d4c9809d5e8e67632662"
  end

  def install
    bin.install "bin/jetzig"
  end

  test do
    system "#{bin}/jetzig"
  end
end
