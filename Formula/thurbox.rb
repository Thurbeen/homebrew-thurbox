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
  version "0.113.0"
  license "MIT"

  depends_on "git"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/Thurbeen/thurbox/releases/download/v#{version}/thurbox-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "b6260c7de9d43407354aa9f845b3341347597454ab5e68d6aea1bb6498cb2d63"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Thurbeen/thurbox/releases/download/v#{version}/thurbox-v#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b55cfe21f7d4b595640dfaf5e34d31c214a64e3928b0102d352aeacc9d1d23ca"
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
      thurbox needs tmux >= 3.2 and a coding-agent CLI (claude, codex, gemini,
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
