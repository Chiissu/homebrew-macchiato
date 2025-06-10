class Zine < Formula
  desc "Fast, Scalable, Flexible Static Site Generator (SSG) "
  homepage "https://zine-ssg.io/"
  version "0.10.2"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://github.com/kristoff-it/zine/releases/download/v#{version}/aarch64-macos.zip"
      sha256 "dd6796e22bd5419ced1df0b03a8f2f9765944910d17615118a5f93ec6710e71f"
    elsif Hardware::CPU.avx2?
      url "https://github.com/kristoff-it/zine/releases/download/v#{version}/x86_64-macos.zip"
      sha256 "ae772e3c3ced004b407551ba54c6fded28319efdfbc5bceaaa77ed13bd3821d7"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoff-it/zine/releases/download/v#{version}/aarch64-linux-musl.tar.xz"
      sha256 "8c178c0173542a7927d975b54f6f8fdd565567160adc53044a4da6f3c3048049"
    elsif Hardware::CPU.avx2?
      url "https://github.com/kristoff-it/zine/releases/download/v#{version}/x86_64-linux-musl.tar.xz"
      sha256 "2918014bb4bae640a0429a1b29dcf5166be92569da0b8aa67087c4fcec9b6400"
    else
      odie "Unsupported Linux architecture."
    end
  else
    odie "Unsupported platform."
  end

  depends_on "zig"

  def install
    bin.install "zine"
  end

  def caveats
    return unless Formula["zig-nominated"].any_version_installed?
    return unless Formula["zig-nightly"].any_version_installed?
    <<~EOS
      ⚠️ You have the nominated and/or nightly zig package installed.
      Zine depends on the release version of zig, which you can switch to by running:
      $ brew link --overwrite zig zls
    EOS
  end

end
