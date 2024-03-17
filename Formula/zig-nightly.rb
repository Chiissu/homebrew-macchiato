class ZigNightly < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.12.0-dev.3342+f88a971e4"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "762f95d4cdb199b80544f9e97cf0d70d88702b89062e28120681973cc8170b44"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "b421d33aea1df281dbf6c5d88f42141250f535ea7afa3517257d87269abe18e2"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "e40b1e8ffc3db3509a0f6a2dbfabf67233a300410f6feadcca857262d9ae1474"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "2790c3dc9cbf7d280ac12f764d03da23bdb1bb2b74f29ce2338ce41b19c28295"
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
      $ brew link --overwrite zig-nightly
      To switch back to the official version, run:
      $ brew link --overwrite zig
    EOS
  end

end
