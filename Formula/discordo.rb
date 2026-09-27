class Discordo < Formula
  desc "A lightweight, secure, and feature-rich Discord terminal client"
  homepage "https://github.com/ayn2op/discordo"
  version "0.1.0-08b4117"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/10893270934.zip"
      sha256 "f498863f190af26a43a8ebf3cb944a1b0efe19eb3136144193dcd157b5848194"
    elsif Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/10893102384.zip"
      sha256 "b0518714521ed521f6d83c1f6ea9f455041544733e30c50a9c6c85e5a9b26cec"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/10893241524.zip"
      sha256 "04bfc6e68ac9b70cfc652c4e0f9efcef13be21c10835dadf0d555b39b663104c"
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
