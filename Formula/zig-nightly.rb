class ZigNightly < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.16.0-dev.13+1594c8055"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-aarch64-macos-#{version}.tar.xz"
      sha256 "031ce5bab0a47833b43bcc5466fd4be16f9741fbb140ac134f74200770cd7128"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-x86_64-macos-#{version}.tar.xz"
      sha256 "09ec8c6872b2d122910baf0590617ace5ad0351d7d56449968981e98ae731f00"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-aarch64-linux-#{version}.tar.xz"
      sha256 "08b8959fe9e0819fbfc2bcc8d780ae55d66ea79eecf40dd56d86b8f793af4118"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-x86_64-linux-#{version}.tar.xz"
      sha256 "4c72e8f1d6a75d0e0d4d479bf1f47a17b89a912653c05154b6c53d180dbf0e66"
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
