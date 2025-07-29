class Discordo < Formula
  desc "A lightweight, secure, and feature-rich Discord terminal client"
  homepage "https://github.com/ayn2op/discordo"
  version "0.1.0-316ce88"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/3642526391.zip"
      sha256 "1a1bf4daa097717485c0557690ba80026ad727872dc9d12087c43dddf42ad620"
    elsif Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/3642526930.zip"
      sha256 "83bd94fdad521fee1628a560246795873e76670727e3d7dd0210e66da6f50544"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/3642527052.zip"
      sha256 "516da820f2ceea05e0ed2a2e44661fd85dd96b9ec07fef40926b3b5bdeaf89ea"
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
