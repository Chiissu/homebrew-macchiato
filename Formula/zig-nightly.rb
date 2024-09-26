class ZigNightly < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.14.0-dev.1660+444228865"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "a1d06af736ac1932f713f56a155e62c6ef71950cb7cc92d6f507d8784251a38f"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "2aa03465065a649472f999bacbc41c97fb1823abc2cd202f080292a756e1f9eb"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "cea11d9a433c29b3944edfe795c96a17f64e4e5b34e27831c7b849c6215bace7"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "075bd7d6d98999a37316f4e05e42ea996577d3cbdbe12f434e70441397d6c839"
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
      ⚠️ You have the official or nominated zig package installed, which conflicts with this nightly version.
      To switch to the nightly version, run:
      $ brew link --overwrite zig-nightly
      To switch back to the official or nominated version, run:
      $ brew link --overwrite zig # or zig-nominated
    EOS
  end

end
