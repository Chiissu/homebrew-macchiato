class ZigNightly < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.17.0-dev.1503+1f1bee62e"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-aarch64-macos-#{version}.tar.xz"
      sha256 "9eceb97df77aaec7b8873fe24f74783adbdf0b88e867547e2ea6449f73bfab67"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-x86_64-macos-#{version}.tar.xz"
      sha256 "8fd4c9de8d97626388e38cb4efb523dbc64dd3452d0ab83f829417f7b99f31eb"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-aarch64-linux-#{version}.tar.xz"
      sha256 "e2b623c02d32bc18c53896a04e9cf4c0c3a783ff3ced5a70caf4e3deceae88b1"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-x86_64-linux-#{version}.tar.xz"
      sha256 "15b4c7b9e20883483b94a83bf9da09200c2ea00e7f0741780f3babcf1b460d2c"
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
    return unless Formula["zig-nominated"].any_version_installed?
    <<~EOS
      ⚠️ You have other version of the zig package installed, which conflicts with this version.
      To use this nominated version, run:
      $ brew link --overwrite zig-nominated
    EOS
  end

end
