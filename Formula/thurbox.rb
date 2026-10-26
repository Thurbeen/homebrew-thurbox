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
  version "2.75.2"
  license "MIT"

  depends_on "git"
  depends_on "tmux"

  on_macos do
    on_arm do
      url "https://github.com/Thurbeen/thurbox/releases/download/v#{version}/thurbox-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "9dac69e95daf28a80ddb43d5f8e714870b56b2de6e7e1fdc460802d72b2b84df"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Thurbeen/thurbox/releases/download/v#{version}/thurbox-v#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f34c11fe659bf9d008764e3e05579399a60ded75f7d52d7c967bcd935a52e582"
    end
    # No release before this block existed shipped the tarball, so the template
    # has no last-known-good sum; bump-formula.py fills it on the first release.
    on_arm do
      url "https://github.com/Thurbeen/thurbox/releases/download/v#{version}/thurbox-v#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "69594d80201f035c80d4ede617d764d0aa1e941185a2cab5aee3b8ba168dc21e"
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
