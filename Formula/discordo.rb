class Discordo < Formula
  desc "A lightweight, secure, and feature-rich Discord terminal client"
  homepage "https://github.com/ayn2op/discordo"
  version "0.1.0-a0ec15d"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://nightly.link/ayn2op/discordo/actions/runs/10450399243/discordo_macOS_ARM64.zip"
      sha256 "bff84c1b6fa998bc61864a7893dd57d874d737f671eba46163ffee206f9c60c6"
    elsif Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/runs/10450399243/discordo_macOS_X64.zip"
      sha256 "20f688adf698758accdb7b62af9a63a942e93d1181f7c0a7a090321a6e910817"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/runs/10450399243/discordo_Linux_X64.zip"
      sha256 "80a438a6ae91673af43c551be2b531554f776acd1692c82a56c223f5666d7f27"
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
