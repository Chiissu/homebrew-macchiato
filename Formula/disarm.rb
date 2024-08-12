class Disarm < Formula
  desc "Quick CLI instruction lookup for ARM64, turned full-fledged binary analyzer"
  homepage "https://newandroidbook.com/tools/disarm.html"
  license "FREE TO USE (AISE)"
  version "2.0-beta4"

  if OS.mac?
    url "http://newosxbook.com/tools/disarm"
    sha256 "8c4699dda1e3ac48cbe7fb42e806f1ba84100481e8261d9378a58d2c052a43a3"
  elsif OS.linux?
    url "http://newosxbook.com/tools/disarm.ELF64"
    sha256 "c9bbda677132d503b2b68624d9db9aa3e4f77c707233451c88b65b7da402f0da"
  end

  def install
    bin.install "disarm"
  end

  test do
    system "#{bin}/disarm"
  end
end
