class Libmediapipe < Formula
  desc "C API for Google's MediaPipe framework"
  homepage "https://github.com/Froxcey/libmediapipe"
  url "https://github.com/Froxcey/libmediapipe/archive/49186c74c9ba0c3d9a850ede3def811572a005b0.zip"
  sha256 "a9ad3d76503422f83d3b82cfb06d94e935de2a0a3e80243586a18189ca811cab"
  license "GPL-3.0"
  version "0.10.15"

  $arch = "x86_64"
  if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
    $arch = "aarch64"
  end

  depends_on "python" => :build
  depends_on "bazelisk" => :build
  depends_on "opencv"

  def install
    system "./build-#{$arch}-macos.sh --config release --opencv_dir #{Formula["opencv"].opt_prefix} --version v#{version}"
    system "sh", "./gen-pkgconfig.sh", "#{opt_prefix}", "#{version}"
    include.install "output/libmediapipe/include/mediapipe.h"
    lib.install "output/libmediapipe/lib/libmediapipe.dylib"
    lib.install "output/libmediapipe/lib/pkgconfig"
    lib.install "output/data"
  end

  test do
    system "false"
  end

  def caveats
    <<~EOS
      ⚠️ THIS IS AN EXPERIMENTAL PACKAGE
      Bugs and frequent updates are to be expected
      Use this at your own risk
    EOS
  end
end
