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
#   - Linux aarch64               -> aarch64-unknown-linux-musl (static)
# Intel macOS has no release binary, so it is omitted (brew reports "no
# available formula" there).
class Thurbox < Formula
  desc "TUI for orchestrating multiple coding-agent CLI sessions in persistent tmux panels"
  homepage "https://github.com/Thurbeen/thurbox"
  version "2.75.5"
  license "MIT"

  depends_on "git"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/Thurbeen/thurbox/releases/download/v#{version}/thurbox-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "e14e2a3b22ac9ba66b7c76209c30960e64cc1f6f6a75d1574424b64cd9755bde"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Thurbeen/thurbox/releases/download/v#{version}/thurbox-v#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dfab3d03576839c1380259529a21da0787c52bce741f0c8064875db6467150b1"
    end
    # No release before this block existed shipped the tarball, so the template
    # has no last-known-good sum; bump-formula.py fills it on the first release.
    on_arm do
      url "https://github.com/Thurbeen/thurbox/releases/download/v#{version}/thurbox-v#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0bfb67c8343eaffb7ae9ab100529ab0fae2f08e9c31ffb1591dcb372440e420c"
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
