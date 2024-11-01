class V2d < Formula
  desc "2D-based VTubing studio"
  homepage "https://github.com/Chiissu/v2d"

  version "0.2.0"
  url "https://github.com/Chiissu/v2d/archive/refs/tags/v#{version}.tar.gz"
  sha256 "a1b9a639a3ada002595eff8a4fa6e8e4063d62bccf0be4e6c0e07ce9cbeb4d05"

  head "https://github.com/Chiissu/v2d.git", branch: "main"

  depends_on "libmediapipe"
  depends_on "opencv"
  depends_on "zig-nominated" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/v2d"
  end
end
