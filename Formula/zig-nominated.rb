class ZigNominated < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://machengine.org/docs/nominated-zig/"
  version "0.17.0-dev.892+54537285c"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://pkg.machengine.org/zig/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "d49201f9389ef57e8725811149795d998490ff2ffa0b379469fcddc0316728cc"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "1329d4bcb26b2db0801a535cc798789f37fc05825c1d942e39b584b0dbb504f2"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://pkg.machengine.org/zig/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "927bf106869c6eedd87234cdcd3ad02550d6f4113fe6fcd624e0c619f50fcf66"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "07696249a07312c29e8ce6cd74049552fcfb7fc6d679730c4b6c3c3f43948455"
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
    return unless Formula["zig-nightly"].any_version_installed?
    <<~EOS
      ⚠️ You have other version of the zig package installed, which conflicts with this version.
      To use this nightly version, run:
      $ brew link --overwrite zig-nightly
    EOS
  end

end
