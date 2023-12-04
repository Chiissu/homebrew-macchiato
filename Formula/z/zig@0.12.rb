class ZigAT012 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.1773+8a8fd47d2"
  license "MIT"

  parts = version.to_s.split(".")

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "fc1d46fc81bca3ffb948ebd9b0bdb1b1c10c7bf5ca4ad25bd27b1083482683c7"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "64898aaabe0d535303b738e17f34498d025ea6b2f9d29622359a38752d08859c"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "b74ed8b3b593a164c7e9af259e000024f59c1f81a050d5a9d823578bc8170236"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "bcaa8e74e832ce3b211a81dc409d888fb355051cf8b86e0c8f0bdff73d5fc7a9"
    else
      odie "Unsupported Linux architecture."
    end
  else
    odie "Unsupported platform."
  end

  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with :gcc

  def install
    bin.install "zig"
    prefix.install "lib"
  end

  def caveats
    return unless Formula["zig"].any_version_installed?
    <<~EOS
      ⚠️ You have the official zig package installed, which conflicts with this nightly version.
      To switch to the nightly version, run:
      $ brew link --overwrite zig@0.12
      To switch back to the official version, run:
      $ brew link --overwrite zig
    EOS
  end

end
