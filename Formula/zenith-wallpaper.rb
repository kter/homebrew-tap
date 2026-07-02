class ZenithWallpaper < Formula
  desc "Render the real night sky overhead as your desktop wallpaper"
  homepage "https://github.com/kter/zenith-wallpaper"
  url "https://github.com/kter/zenith-wallpaper/archive/refs/tags/v1.6.tar.gz"
  sha256 "a4985b555c3e7e11e03c7e95c7d573dd1f9fcdf3ef8591aa793de2d9a4f7dfe5"
  license "MIT"

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  service do
    run [opt_bin/"zenith-wallpaper"]
    run_type :interval
    interval 3600
    log_path var/"log/zenith-wallpaper.log"
    error_log_path var/"log/zenith-wallpaper.log"
  end

  def caveats
    <<~EOS
      zenith-wallpaper sets the wallpaper by scripting System Events, which
      needs a one-time Automation approval. Run it once from Terminal and
      accept the prompt:
        zenith-wallpaper

      Then enable hourly updates with:
        brew services start zenith-wallpaper

      On macOS Sonoma and later the wallpaper is applied to the current
      Space of each display; other Spaces keep their existing wallpaper.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zenith-wallpaper --version")
  end
end
