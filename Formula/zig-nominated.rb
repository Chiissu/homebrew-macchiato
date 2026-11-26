class ZigNominated < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://machengine.org/docs/nominated-zig/"
  version "0.18.0-dev.935+ead8f5a7a"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://pkg.machengine.org/zig/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "86917e13b3312d34f0f58d206986a7927dd608ce31f21712cace4758043c80ce"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "95f4939ba491970a74001c291b7e88e73ff3505f5a9115e4e9b9af6eb9fec660"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://pkg.machengine.org/zig/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "37902e91ffbdbaf3e62bf94ba3c7721da13a7d0dbf89a3378d30f5100d3ac0b2"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "76258449f1088b6f80359944f9735a4c96e94246e553111155f0af6457ff8de4"
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
