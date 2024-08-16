class Libmediapipe < Formula
  desc "C API for Google's MediaPipe framework"
  homepage "https://github.com/Froxcey/libmediapipe"
  url "https://github.com/Froxcey/libmediapipe/archive/759abd3968e676a3f5192bb08dca993155bac8c6.zip"
  sha256 "9e55fcbc96d20716f8510f0d350d3ea809af4c4b151407aa411f0e0ac60572a5"
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
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test openpose`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "false"
  end
end
