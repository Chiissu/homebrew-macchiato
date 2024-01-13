class Sdl3Nightly < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  version "101f903bb1b6c0163d1ccf5b02b9ebfc3757b140"
  url "https://codeload.github.com/libsdl-org/SDL/tar.gz/#{version}"
  sha256 "d4ac48bd4f89684aedd71dfcef2db5b91432c0ccbb86cba07c4507e50179f1b3"
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
