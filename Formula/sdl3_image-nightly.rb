class Sdl3ImageNightly < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  version "41105d5c52f97752a6f9585c47bb33c61f7c1f21"
  url "https://codeload.github.com/libsdl-org/SDL_image/tar.gz/#{version}"
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
