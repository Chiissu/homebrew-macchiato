class ZigNominated < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://machengine.org/docs/nominated-zig/"
  version "0.17.0-dev.2228+955228b68"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://pkg.machengine.org/zig/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "43a882ac4704d30685928d3c4f3c7d62b4ce286a875df88bc0b206931bd0b0d1"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "ab349382776df44c6fcd76278c8c750a765000bdcc5c2edc0f0fd52557b8b69f"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://pkg.machengine.org/zig/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "defa288a18ca62164d62b405a78be22ede0d0827841c2f060624d0e1511ba96c"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "7ba127e73adeafd25aee6a16cc6008486c93ea0fcec5bff9d7c6b035785b22c3"
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
