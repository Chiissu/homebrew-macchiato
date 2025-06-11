class Superhtml < Formula
  desc "HTML Language Server & Templating Language Library"
  homepage "https://github.com/kristoff-it/superhtml"
  version "0.5.3"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://github.com/kristoff-it/superhtml/releases/download/v#{version}/aarch64-macos.tar.xz"
      sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    elsif Hardware::CPU.avx2?
      url "https://github.com/kristoff-it/superhtml/releases/download/v#{version}/x86_64-macos.tar.gz"
      sha256 "48d0d755867a0a7081d4ab9c658a66fcdcd32315fc6d4ea734e5ee34e49b0468"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoff-it/superhtml/releases/download/v#{version}/aarch64-linux.tar.gz"
      sha256 "54cd2414de6664b85166a0a2e7c208ca3dbcc935274f4a55309cc9dcfa8e605b"
    elsif Hardware::CPU.avx2?
      url "https://github.com/kristoff-it/superhtml/releases/download/v#{version}/x86_64-linux-musl.tar.gz"
      sha256 "c9fabbbd57851e38a67e6c1eb7942e8bc6189925bfcf437f1e5286932c76d60a"
    else
      odie "Unsupported Linux architecture."
    end
  else
    odie "Unsupported platform."
  end

  def install
    bin.install "superhtml"
  end
end
