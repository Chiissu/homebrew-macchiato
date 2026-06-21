class ZigNightly < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "0.17.0-dev.947+36069a2a7"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-aarch64-macos-#{version}.tar.xz"
      sha256 "28394dc7436b22686c883446f992fb51daa35f307fa59b0d1ec6195f47157c12"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-x86_64-macos-#{version}.tar.xz"
      sha256 "bbca87f79379e4b6431452870701524fd4020d92f91c62a46eeabd9eb592f720"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-aarch64-linux-#{version}.tar.xz"
      sha256 "61f89276620cf08b32e974245b34cb0e3a101a23877754a2fd542c9bf0efd793"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-x86_64-linux-#{version}.tar.xz"
      sha256 "5ee10a5d9d7e3ac6f9edbb25e51b00c0912a9faa4c55b2455b2a24ac8635e6cf"
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
