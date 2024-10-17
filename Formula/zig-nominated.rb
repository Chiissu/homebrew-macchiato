class ZigNominated < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://machengine.org/docs/nominated-zig/"
  version "0.14.0-dev.1911+3bf89f55c"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://pkg.machengine.org/zig/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "fde79992e2f60d8a9155cf0d177c7c84db2a5729f716419660fc75f5d1ed2a95"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "07dab7e71d61465bebed305d2c8bfae53c5f3b9422dd8e481f1b04bf3812c54b"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://pkg.machengine.org/zig/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "d37e7c596b0bb86e3160eb0f25c8951d7f31ed78dd3f127c701fa9ff95b49298"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "73347307b8fcc4d5aab92b7c39f41740ae7b8ee2a82912aecb8cbbf7b6f899fd"
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
      ⚠️ You have the official or nightly zig package installed, which conflicts with this nominated version.
      To switch to the nominated version, run:
      $ brew link --overwrite zig-nominated
      To switch back to the official or nightly version, run:
      $ brew link --overwrite zig # or zig-nightly
    EOS
  end

end
