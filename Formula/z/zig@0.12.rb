class ZigAT012 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.1753+a98d4a66e"
  license "MIT"

  parts = version.to_s.split(".")

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "ff66079cbb860bc7db1339097be33fdb42a6f088a741557ceae23dafcb9d56ee"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "a23c927ec9a9cf9ef9d83561551ba7fa2046076b2f9813e8bfad9a5b80589bac"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "91c1d4bf2cd8d01979a467a3015d64a5b3b168f69972ee699dc6116f5661e270"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "f24000d71c08d14fd8a32a43f34b420c837147b58569dc95a1cc9d17707178e1"
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
