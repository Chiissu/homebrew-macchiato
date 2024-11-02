class V2d < Formula
  desc "2D-based VTubing studio"
  homepage "https://github.com/Chiissu/v2d"

  version "0.2.1"
  url "https://github.com/Chiissu/v2d/archive/refs/tags/v#{version}.tar.gz"
  sha256 "36aa43b7ca8396433e5179310cbe4a5880b8ce290bb79f7e50d16f07aab7f8bd"

  head "https://github.com/Chiissu/v2d.git", branch: "main"

  depends_on "libmediapipe"
  depends_on "opencv"
  depends_on "zig-nominated" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/v2d"
  end
end
