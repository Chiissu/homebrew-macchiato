class Sdl3Nightly < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  version "649556befa156201116a4f25089597463d0efd44"
  url "https://codeload.github.com/libsdl-org/SDL/tar.gz/#{version}"
  sha256 "5490459af59f58f0e552ebe5185c552c232fe4da9cc438df5686c053a8ac139d"
  license "Zlib"

  depends_on "cmake"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system bin/"sdl3-config", "--version"
  end
end
