class Discordo < Formula
  desc "A lightweight, secure, and feature-rich Discord terminal client"
  homepage "https://github.com/ayn2op/discordo"
  version "0.1.0-37cd42c"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/11450558332.zip"
      sha256 "16d9f93a8f34a1c48a9c1d718f35a5d78fb7ad2818055e5fb9c29c13281393b3"
    elsif Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/11451172811.zip"
      sha256 "c4c613a3ed7489a9a7398b6d0972e3683b16ba538d2b39781ea14fc340ecca5c"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/11450364742.zip"
      sha256 "9386c13349b61c84bdcf3d38a889f6a0a72c6d0a227f38f8851868924005d7a8"
    else
      odie "Unsupported Linux architecture."
    end
  else
    odie "Unsupported platform."
  end

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w")
    else
      bin.install "discordo"
    end
  end

  head do
    url "https://github.com/ayn2op/discordo.git", branch: "main"
    depends_on "go" => :build
  end

  test do
    system "false"
  end
end
