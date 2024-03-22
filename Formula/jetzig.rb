class Jetzig < Formula
  desc "A web framework written in Zig"
  homepage "https://www.jetzig.dev"
  license "MIT"
  version "bf62fdc"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://www.jetzig.dev/build-macos-aarch64.zip"
      sha256 "43ea9700cb504e13fe48d28a3c9a59a13d81deda503367a72e662b13eff01023"
    elsif Hardware::CPU.avx2?
      url "https://www.jetzig.dev/build-macos-x86.zip"
      sha256 "9f6bda546b2579e07720c4a57fcee5660ee2a6bfe05a055f7e84fa242852e45a"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    url "https://www.jetzig.dev/build-linux.zip"
    sha256 "9c764c08ee980c670ac2f4ec98637ecbf5e0cb991bdcbab6e949298b99a85db6"
  end

  def install
    bin.install "bin/jetzig"
  end

  test do
    system "#{bin}/jetzig"
  end
end
