class Libmediapipe < Formula
  desc "C API for Google's MediaPipe framework"
  homepage "https://codeberg.org/Chiissu/libmediapipe"
  license "GPL-3.0"
  version "0.10.22"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://codeberg.org/Chiissu/libmediapipe/releases/download/v#{version}/libmediapipe-macos-aarch64-#{version}.tar.gz"
      sha256 "5570d22079074ecc8b5e46bfd3b9a4080c8ffa623a6fb942b827c991f8e65bf8"
    elsif Hardware::CPU.avx2?
      url "https://codeberg.org/Chiissu/libmediapipe/releases/download/v#{version}/libmediapipe-macos-x86_64-#{version}.tar.gz"
      sha256 "2ca26a2a39802c624897b9c80bb1dc870ed44fbdd6cae69d25be6534937b9ee1"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.avx2?
      url "https://codeberg.org/Chiissu/libmediapipe/releases/download/v#{version}/libmediapipe-linux-x86_64-#{version}.tar.gz"
      sha256 "531a1e2b7090044a0dbc31a18b55a69ded60ea7bb95de4f6f78c98180399f688"
    else
      odie "Unsupported Linux architecture."
    end
  else
    odie "Unsupported platform."
  end

  depends_on "opencv"

  def install
    system "sh", "./pkgconfig/gen-pkgconfig.sh", "#{opt_prefix}", "#{version}"
    include.install "libmediapipe/include/mediapipe.h"
    if OS.mac?
      lib.install "libmediapipe/lib/libmediapipe.dylib"
    else
      lib.install "libmediapipe/lib/libmediapipe.so"
    end
    lib.install "libmediapipe/pkgconfig"
    lib.install "data"
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
