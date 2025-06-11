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
    sha256 "47fd0a99aedd189ff389def7299c2d178faa69bd53db615b575d813d81ef8824"
  end

  def install
    bin.install "disarm"
  end

  test do
    system "#{bin}/disarm"
  end
end
