class ZigNightly < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.15.0-dev.63+aa3db7cc1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "4fc59c67aca0cb60bca43ae667d4124fe6ae3df9c4a33ba4593116e3f89bc2ca"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "f27298c809230db40efe2948b3eebd23bc01d2183845105dc9ac7eee6dd39d54"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "916f732c7df86e6a9479bc03e751121e547a006362bde526f6cfb58bae26ea2f"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "1a89e6f49868c614d19af27174ac0b6355589599ed9c6754510ea1bcfb0ae4db"
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
