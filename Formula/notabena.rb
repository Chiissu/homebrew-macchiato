class Notabena < Formula
  desc "Pure Rust open-source note-taking app"
  homepage "https://github.com/ThatFrogDev/notabena"

  version "0.2.0"
  url "https://github.com/ThatFrogDev/notabena/archive/refs/tags/v#{version}.tar.gz"
  sha256 "aa545a95d1bb1b055e6847432e473e7170b1cc05e9c3711fe43ca5a43f822173"
  license "GPL-3.0"

  head "https://github.com/ThatFrogDev/notabena.git", branch: "dev"

  depends_on "rust" => :build

  def install
    system "cargo", "b", "-r"
    bin.install "target/release/notabena"
  end
end
