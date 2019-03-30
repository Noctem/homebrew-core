class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library by Rasterbar Software"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent_1_2_0/libtorrent-rasterbar-1.2.0.tar.gz"
  sha256 "428eefcf6a603abc0dc87e423dbd60caa00795ece07696b65f8ee8bceaa37c30"
  head "https://github.com/arvidn/libtorrent.git"

  bottle do
    cellar :any
    sha256 "53d91bed31cef91eb32b80c67adca1ea6e97206d15415210b4de602164cba7fd" => :mojave
    sha256 "4f128c474c9e20216448c9c4b04cee3cf382c57455a9acf83154518c0c0c2d07" => :high_sierra
    sha256 "fa8e3ed74f54270abcc6f46e13c70590b1ed2556fc46ebeba8e3e9e2f2c0334d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl"
  depends_on "python"

  def install
    ENV.cxx11

    system "cmake", ".",
                    "-DCMAKE_CXX_STANDARD=11",
                    "-Dpython-bindings=ON",
                    "-DPYTHON_EXECUTABLE=#{Formula["python"].bin/"python3"}",
                    "-G", "Ninja",
                    *std_cmake_args
    system "ninja", "install"
  end

  test do
    system ENV.cxx, "-L#{lib}", "-ltorrent-rasterbar",
           "-I#{Formula["boost"].include}/boost",
           "-L#{Formula["boost"].lib}", "-lboost_system",
           libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
