class Libmediapipe < Formula
  desc "C API for Google's MediaPipe framework"
  homepage "https://codeberg.org/Chiissu/libmediapipe"
  license "GPL-3.0"
  version "0.10.22"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://codeberg.org/Chiissu/libmediapipe/releases/download/v#{version}/libmediapipe-macos-aarch64-#{version}.tar.gz"
      sha256 "70d0148e2cfdb27fe047c6a90cd37a504713babe73cd1a64a024804fd46a4db5"
    elsif Hardware::CPU.avx2?
      url "https://codeberg.org/Chiissu/libmediapipe/releases/download/v#{version}/libmediapipe-macos-x86_64-#{version}.tar.gz"
      sha256 "d2e6f621ff5838569a6ebde0856ced2948b311447338fd51f53a492060f52985"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.avx2?
      url "https://codeberg.org/Chiissu/libmediapipe/releases/download/v#{version}/libmediapipe-linux-x86_64-#{version}.tar.gz"
      sha256 "c66d6aa36caa40efdb16f6de8f7ab042adba882fd41df515b5e782be0e150e0e"
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
