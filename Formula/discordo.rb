class Discordo < Formula
  desc "A lightweight, secure, and feature-rich Discord terminal client"
  homepage "https://github.com/ayn2op/discordo"
  version "0.1.0-eaaf87c"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/6608396100.zip"
      sha256 "067fe7b247af4a7759a597c976d41fc77876ad83ac2fc5432ad26fbf9e7d56e8"
    elsif Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/6608444117.zip"
      sha256 "c0187bf6cdd20139844386aff64abe287af45279868be3349bb239b4b036a254"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.avx2?
      url "https://nightly.link/ayn2op/discordo/actions/artifacts/6608392552.zip"
      sha256 "953e17116ba743578f69fe59686e42f9ddb30f94225fb37fd36546b2ef9ec4c9"
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
