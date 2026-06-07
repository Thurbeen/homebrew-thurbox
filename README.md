# homebrew-thurbox

Homebrew tap for [thurbox](https://github.com/Thurbeen/thurbox) — a TUI for
orchestrating multiple coding-agent CLI sessions in persistent tmux panels.

```bash
brew install thurbeen/thurbox/thurbox
# or:
brew tap thurbeen/thurbox
brew install thurbox
```

Installs the prebuilt release binaries (`thurbox` + `thurbox-cli`) with `tmux`
and `git` as dependencies. Supports macOS arm64 (Apple Silicon) and Linux
x86_64.

> This tap is updated automatically on every thurbox release by the
> `publish-homebrew` job in the
> [main repo's release workflow](https://github.com/Thurbeen/thurbox/blob/main/.github/workflows/cd.yml).
> The canonical formula source lives at
> [`packaging/homebrew/Formula/thurbox.rb`](https://github.com/Thurbeen/thurbox/blob/main/packaging/homebrew/Formula/thurbox.rb).
