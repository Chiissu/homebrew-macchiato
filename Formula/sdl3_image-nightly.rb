class Sdl3ImageNightly < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  version "be035537a9ee0e4990c57809446b4776754980cd"
  url "https://codeload.github.com/libsdl-org/SDL_image/tar.gz/#{version}"
  sha256 "66ce41b4af9dd41b6847cc4edcb172ff4de8010553011d6cd831f5c21786f361"
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
