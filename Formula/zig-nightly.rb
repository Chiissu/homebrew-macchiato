class ZigNightly < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.14.0-dev.362+9d9b5a11e"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-#{version}.tar.xz"
      sha256 "22d0bb6a34f370647211c9142a65607a11002142b279ef5c69b5951d4d2540c8"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-#{version}.tar.xz"
      sha256 "60109bf174c8df0014d621a0d109bdfedea5020636f0868e031aa6d748995d1f"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-#{version}.tar.xz"
      sha256 "233f3cb108a20ce30ec1d665ae924b6efa2a59f63d04394e8c141f6ee3fd1da3"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-#{version}.tar.xz"
      sha256 "9a603ac3effffbc44fca4cd664f480fbc92a0ceed9f7466d3707d2360fca367c"
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
