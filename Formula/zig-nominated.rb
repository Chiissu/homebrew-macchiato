class ZigNominated < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://machengine.org/docs/nominated-zig/"
  version "0.16.0-dev.3142+5ccfeb926"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://pkg.machengine.org/zig/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "0ab967ed551814e7450ce9b6dc11853c96697e9307b8f9bb4283669d3a9860a8"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "7ff94c3c5b70e6b90a9aa74308e05f36620a1c0f2b5c7b62635310eb1c93310b"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://pkg.machengine.org/zig/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "4801ddd0fe720e5b0c177230caa2301ed3ce2e3701beec6c18888b49244c1a5a"
    elsif Hardware::CPU.avx2?
      url "https://pkg.machengine.org/zig/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "ab4e7bf6358a63e50aeec2243547b63791c75523685ad458d0c339448d723a88"
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
