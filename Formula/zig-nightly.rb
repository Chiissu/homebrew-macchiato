class ZigNightly < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.18.0-dev.1124+2ecf4b5e2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-aarch64-macos-#{version}.tar.xz"
      sha256 "8491a8470c5a1b6c4af866548c1031b214de99503d52f57ed3290a3f471bd094"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-x86_64-macos-#{version}.tar.xz"
      sha256 "251b7a5115c328f499d888da2e8223e41b40a1417a18d810a2bcbe6370c6693a"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-aarch64-linux-#{version}.tar.xz"
      sha256 "2187ceafbefa2b04121749e398e2bf5cbc8fb64ed348d948a2e1c5b018f716c9"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-x86_64-linux-#{version}.tar.xz"
      sha256 "07a8889c65fb0ca6ac76e1c11d0ba9e4aeeeba4f0c9c0bd75005e372f82b665f"
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
