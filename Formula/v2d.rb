class V2d < Formula
  desc "2D-based VTubing studio"
  homepage "https://github.com/Chiissu/v2d"

  version "0.1.1"
  url "https://github.com/Chiissu/v2d/archive/refs/tags/v#{version}.tar.gz"
  sha256 "2e86f6fd66bf557669f0d0a6b04b0a4e587019b8b53496ca5d4a03cb1f1c4854"

  head "https://github.com/Chiissu/v2d.git", branch: "main"

  depends_on "libmediapipe"
  depends_on "opencv"
  depends_on "zig-nominated" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/v2d"
  end
end
