class ZigAT012 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "1697+6fc20b3b0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.12.0-dev.#{version}.tar.xz"
      sha256 "f0c63fc88bac9e557484350849cee7311410a538c3880554c7b3ddc2d57f2875"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-macos-x86_64-0.12.0-dev.#{version}.tar.xz"
      sha256 "d499942262203f84136ef24eda957b5b17105adffe8fc59ff3274566a33260d7"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.12.0-dev.#{version}.tar.xz"
      sha256 "d38bbd4625349fd8577e3e10f099da49fbc25ced77afd1e3a58e58ac497c7c56"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.12.0-dev.#{version}.tar.xz"
      sha256 "63ce600266901607e155c668a97211c98d09390e139d50175a7851e23f23e2eb"
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

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end
