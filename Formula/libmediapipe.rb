class Libmediapipe < Formula
  desc "C API for Google's MediaPipe framework"
  homepage "https://github.com/Froxcey/libmediapipe"
  url "https://github.com/Froxcey/libmediapipe/archive/9b8cc42475ca4570f8478f99a24e212d69e64676.zip"
  sha256 "bcd6313668794ac56b87aad95cc7e7afde46a158c5249a03f6cdc4d5fc9743a5"
  license "GPL-3.0"
  version "0.10.14"

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
