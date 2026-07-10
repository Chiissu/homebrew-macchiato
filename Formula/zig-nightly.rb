class ZigNightly < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.17.0-dev.1282+c0f9b51d8"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-aarch64-macos-#{version}.tar.xz"
      sha256 "6e25624fd871a76d2604cf7c5ab0984c645b81008607c6ea3d974a3b68405988"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-x86_64-macos-#{version}.tar.xz"
      sha256 "f8103f2bb178ef4c2bbcae62a5480c2327e7aebd4a6dc01345837645be433cf4"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-aarch64-linux-#{version}.tar.xz"
      sha256 "428dac6f697b908a5f64b4c383d57ed3cd40c8968e6440d72f5917819f39c7ae"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-x86_64-linux-#{version}.tar.xz"
      sha256 "6d81dec0152f6f11f8a12a84a73535b65070fe01b14a1ce75423870d65b3f270"
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
