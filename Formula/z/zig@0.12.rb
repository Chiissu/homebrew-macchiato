class ZigAT012 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.1741+2549de80b"
  license "MIT"

  parts = version.to_s.split(".")

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "a3a850433e9f5adb2ca07c4d42fec342bfb5618d4f5ae5c74397aeb184dbfcdd"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "936d77db5e63a0c93ca863452095d67f4b8174b2e270de9562db465e29dade7c"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "7612132aca3993dfd4e797c42e1d1f66876e8631e05793f92ce54dfcd1d029a7"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "623e5bcd7d2f43871a68a40dd6f348b3b1cc7813b8ed6f0c122b7b5068e7be7c"
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
      You might want to run
      $ brew link --overwrite zig@0.12
      to switch to the 0.12 version.
      To switch back to the official version, run
      $ brew link --overwrite zig
    EOS
  end

end
