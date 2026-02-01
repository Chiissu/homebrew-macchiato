class Discordo < Formula
  desc "A lightweight, secure, and feature-rich Discord terminal client"
  homepage "https://github.com/ayn2op/discordo"
  version "0.1.0-25c062e"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/5335552192.zip"
      sha256 "6849c39b5dad6caa48136d5f79bf3724e77e18c3d2dc41811a4cfeff10624d6e"
    elsif Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/5335553004.zip"
      sha256 "e1ab96f75e3f32997133abc33b304b3f5f4f37ad881c1a22a954390296abfbf4"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/5335552464.zip"
      sha256 "d7d4c2c5270f190397efd44fc3027aa4211c7155ce60b67e06d660e57a74957e"
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
