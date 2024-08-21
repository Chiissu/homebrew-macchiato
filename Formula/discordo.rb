class Discordo < Formula
  desc "A lightweight, secure, and feature-rich Discord terminal client"
  homepage "https://github.com/ayn2op/discordo"
  version "0.1.0-c5a65d0"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://nightly.link/ayn2op/discordo/actions/runs/10476852338/discordo_macOS_ARM64.zip"
      sha256 "3658b6f7ba1c363bc3e9493460f449e79dd1757442a45da8ec16b11cb960d298"
    elsif Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/runs/10476852338/discordo_macOS_X64.zip"
      sha256 "9b5330eeeb0387faf1d45dc7efb8c48a8b8c50ec6af54d34e577b463c119c581"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/runs/10476852338/discordo_Linux_X64.zip"
      sha256 "7bcfd1a9e3dd8daaf4568e27efb14451c650dc01f0e9d65b0f98ce883d4b46df"
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
