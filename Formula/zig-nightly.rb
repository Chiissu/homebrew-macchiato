class ZigNightly < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.14.0-dev.541+2e8acdf6f"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "dc077057745bc33f0f6cd657caa867e4633c462f8683c5d747148ec6691511f2"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "91ad57400822cc98afb3f5ff480ad4308c0982191936a4173d869ed3167ca0e5"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "c13221c301ee4005b8c300abbdee3fc605edac50b6d9ab6cfd2a5be6f2f432cc"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "3d904c5ad3b9b46cd8a398220b9f4bbf45e139403fa24a4597e95ab430541317"
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
      $ brew link --overwrite zig-nightly
      To switch back to the official version, run:
      $ brew link --overwrite zig
    EOS
  end

end
