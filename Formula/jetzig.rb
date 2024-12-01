class Jetzig < Formula
  desc "A web framework written in Zig"
  homepage "https://www.jetzig.dev"
  license "MIT"
  version "be8e517"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://www.jetzig.dev/build-macos-aarch64.zip"
      sha256 "3f3ab4e30a947a78b81d54f7f7df9216ed7ea5637efc376a77af16f89056fd78"
    elsif Hardware::CPU.avx2?
      url "https://www.jetzig.dev/build-macos-x86.zip"
      sha256 "5230b10e8fda6ddccb955bdd2475ae5b652df8210eabb6fea529aac1234d9608"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    url "https://www.jetzig.dev/build-linux.zip"
    sha256 "b0aabc50481dce29eb9fc0a71f804e4a1fd16378d3f712c57bb0e4fe28b695df"
  end

  def install
    bin.install "bin/jetzig"
  end

  test do
    system "#{bin}/jetzig"
  end
end
