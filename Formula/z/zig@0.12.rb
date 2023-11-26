class ZigAT012 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.1733+648f592db"
  license "MIT"

  parts = version.to_s.split(".")

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "c79ec3d352f783fa892a5d9d79010ae81f78d43d7967ae2bd03e79f3d4f12744"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "2800311cb737f1b1f9f853f11258e07c531ce3a04406954004518b6691a9d4e9"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "d563a3a76f98465a1abc2686ae2e1423a6e5dc31ca02017a683d6498b9013a65"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.12.#{parts[0]}-dev.#{parts[1]}.tar.xz"
      sha256 "af55facffff89b3c1e73a5fd6196aded007d2862353a1533908454ea91c20ef1"
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
      You might want to run
      $ brew link --overwrite zig@0.12
      to switch to the 0.12 version.
      To switch back to the official version, run
      $ brew link --overwrite zig
    EOS
  end

end
