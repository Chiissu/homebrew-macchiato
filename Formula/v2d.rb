class V2d < Formula
  desc "2D-based VTubing studio"
  homepage "https://github.com/Chiissu/v2d"

  version "0.1.0"
  url "https://github.com/Chiissu/v2d/archive/refs/tags/v#{version}.tar.gz"
  sha256 "ba0d1803314f90c0038c569175279fd6b82c78d2c28e6870529d28e3b1d02617"

  head "https://github.com/Chiissu/v2d.git", branch: "main"

  depends_on "libmediapipe"
  depends_on "opencv"
  depends_on "zig-nominated" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/v2d"
  end
end
