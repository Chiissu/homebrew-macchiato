class Sdl3Nightly < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  version "784311c20ee71d769b14f8d500da6c60e2d2b451"
  url "https://codeload.github.com/libsdl-org/SDL/tar.gz/#{version}"
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
