class Ziggy < Formula
  desc "A data serialization language for expressing clear API messages, config files, etc."
  homepage "https://ziggy-lang.io/"
  version "0.0.1"
  license "MIT"

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://github.com/kristoff-it/ziggy/releases/download/#{version}/aarch64-macos.tar.xz"
      sha256 "1d96c647c414afefb0349bf923148bf95410bb98e554f772bbdada8b99a78d3b"
    elsif Hardware::CPU.avx2?
      url "https://github.com/kristoff-it/ziggy/releases/download/#{version}/x86_64-macos.tar.xz"
      sha256 "609342baa924170acd1b4736a3f04fb80760293111a3edff73dd96e0ac8f0ebc"
    else
      odie "Unsupported MacOS architecture."
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoff-it/ziggy/releases/download/#{version}/aarch64-linux.tar.xz.test.xz"
      sha256 "299003e3668f841c51eb4afc1861da952ad88166480999226f4abfee65f71885"
    elsif Hardware::CPU.avx2?
      url "https://github.com/kristoff-it/ziggy/releases/download/#{version}/x86_64-linux-musl.tar.xz"
      sha256 "71c583b9971ac8712a193f15757edc6a3f058a705cf74922c966611d0a866585"
    else
      odie "Unsupported Linux architecture."
    end
  else
    odie "Unsupported platform."
  end

  def install
    bin.install "ziggy"
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
