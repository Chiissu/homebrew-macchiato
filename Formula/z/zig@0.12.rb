class ZigAT012 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.1819+5c1428ea9"
  license "MIT"

  parts = version.to_s.split(".")

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "a18539d9214931ed630702bfc8dce26ce75750775b516405c1e5a32e872b840f"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "db0e7670e9b9f4211e9b06d3903f0ecee9531129e507abb6874cef100ea56025"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "6e1f326a1cf00f9c84af787ae1932a0356dc4cd98f534e069ed93dcee4bd94ac"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "f112e21c1781dd5e850a2545286ee2ccbc8eff98f4fa34437c84ce8022ea51c0"
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
    <<~EOS
      ⚠️ You have the official zig package installed, which conflicts with this nightly version.
      To switch to the nightly version, run:
      $ brew link --overwrite zig@0.12
      To switch back to the official version, run:
      $ brew link --overwrite zig
    EOS
  end

end
