class Notabena < Formula
  desc "Notabena, the pure Rust open-source note-taking app."
  homepage "https://github.com/ThatFrogDev/notabena"
  head "https://github.com/ThatFrogDev/notabena.git", branch: "stable"

  depends_on "rust" => :build

  def install
    # Use "cargo build" to build the package
    system "cargo", "build", "--release"

    # Install the binary to the Homebrew prefix
    bin.install "target/release/notabena"
  end

  def uninstall
    data_directory = "#{HOMEBREW_PREFIX}/etc/notabena"
    rm_rf data_directory
  end
end
