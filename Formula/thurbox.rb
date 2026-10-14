# Homebrew formula for thurbox.
#
# This is the canonical source, kept in the main repo. CI (the
# `publish-homebrew` job in .github/workflows/cd.yml) copies it to the
# Thurbeen/homebrew-thurbox tap on every release, with `version` and the
# per-platform `sha256` values bumped to that release. The values below are
# a last-known-good template — CI overrides them per release.
#
#   brew install thurbeen/thurbox/thurbox
#
# Only the platforms with a published release artifact are supported:
#   - macOS arm64 (Apple Silicon) -> aarch64-apple-darwin
#   - Linux x86_64                -> x86_64-unknown-linux-musl (static)
# Intel macOS and aarch64 Linux have no release binary, so they are omitted
# (brew reports "no available formula" on those platforms).
class Thurbox < Formula
  desc "TUI for orchestrating multiple coding-agent CLI sessions in persistent tmux panels"
  homepage "https://github.com/Thurbeen/thurbox"
  version "2.58.20"
  license "MIT"

  depends_on "git"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/Thurbeen/thurbox/releases/download/v#{version}/thurbox-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "55c463b1167936aa2ba52e8a785619967330ce82702729469e1b3b7130a6b561"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Thurbeen/thurbox/releases/download/v#{version}/thurbox-v#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "eb00e4312a48ecafe02a7b0f8aacf3ab016d34b855352d0b3f4636a4ea38d27f"
    end
  end

  def install
    # The release tarball ships both maintained binaries plus LICENSE; install
    # only the binaries (Homebrew records the license from the formula).
    bin.install "thurbox"
    bin.install "thurbox-cli"
  end

  def caveats
    <<~EOS
      thurbox needs tmux >= 3.2 and a coding-agent CLI (claude, codex, antigravity,
      opencode, aider, …) on your PATH. Launch the TUI with `thurbox`; the
      scriptable headless interface is `thurbox-cli`.
    EOS
  end

  test do
    # The TUI (`thurbox`) has no headless mode, so only assert it is installed
    # and executable. `thurbox-cli` is a clap CLI: `--version` exits 0 and
    # prints a semver-shaped marker (the build-time release version is injected
    # into the TUI's status bar, not into clap's CARGO_PKG_VERSION).
    assert_predicate bin/"thurbox", :executable?
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/thurbox-cli --version"))
  end
end
