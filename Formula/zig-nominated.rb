class ZigNominated < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://machengine.org/docs/nominated-zig/"
  version "0.13.0-dev.351+64ef45eb0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://pkg.machengine.org/zig/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "fef4c33cc8b2c9af1caf47df98786c6bc049dd70ec6c05c794a3273b2937801b"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "7de18dfc05fc989629311727470f22af9e9e75cb52997c333938eef666e4396e"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://pkg.machengine.org/zig/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "20b9602db87482a1b03ca61acaac6acc17e6e3dc2e46d3521430a6aac3e8c4ef"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "351bcaa1b43db30dc24fb7f34dc598fd7ee4d571f164a4e9bc6dac6f6e6e3c56"
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
