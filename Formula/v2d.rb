class Libmediapipe < Formula
  desc "C API for Google's MediaPipe framework"
  homepage "https://github.com/Froxcey/V2D"
  version ""

  url ""
  sha256 ""

  depends_on "libmediapipe"
  depends_on "opencv"
  depends_on "zig-nominated" => :build

  def install
    system "zig build"
    bin.install "zig-out/bin/v2d"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test openpose`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "false"
  end
end
