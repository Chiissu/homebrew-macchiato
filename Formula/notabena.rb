class Notabena < Formula
  desc "Pure Rust open-source note-taking app"
  homepage "https://github.com/ThatFrogDev/notabena"

  version "0.2.0"
  url "https://github.com/ThatFrogDev/notabena/archive/refs/tags/v#{version}.tar.gz"
  sha256 "900621a586aa5b3ff568920511401c0169175228cc7b32f03ba6f67931fadbda"
  license "GPL-3.0"

  head "https://github.com/ThatFrogDev/notabena.git", branch: "dev"

  depends_on "rust" => :build

  def install
    system "cargo", "b", "-r"
    bin.install "target/release/notabena"
  end
end
