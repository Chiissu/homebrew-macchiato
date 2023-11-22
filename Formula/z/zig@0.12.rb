class ZigAT012 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  version "1669+c25f2fa56"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://ziglang.org/builds/zig-macos-aarch64-0.12.0-dev.#{version}.tar.xz"
      sha256 "bf6265582e3de488d397d5a7c2a586058991829dcc7241e10bb4e96d48f7c85c"
    else
      url "https://ziglang.org/builds/zig-macos-x86_64-0.12.0-dev.#{version}.tar.xz"
      sha256 "d372f2fc63078cc2b42d8542e0d5ee209c58ae642904eb0d6a86adc5c1c3364b"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://ziglang.org/builds/zig-linux-aarch64-0.12.0-dev.#{version}.tar.xz"
      sha256 "586f18df3976ea02ef534869c60be8f95d6a8658c7cf0b54769a7a99e38e7f6f"
    elsif Hardware::CPU.avx2?
      url "https://ziglang.org/builds/zig-linux-x86_64-0.12.0-dev.#{version}.tar.xz"
      sha256 "5b9c76e3302c121f576183c4ee9419c8d0a0f62202ebde8b21ec753a7477272a"
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
