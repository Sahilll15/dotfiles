# GITHUB_TOKEN is deliberately NOT exported here.
#
# .zshenv loads unconditionally, including for non-login shells, so an export
# here overrode gh's own stored credentials on every shell. Since 2026-08-05
# gh uses its keyring instead. The token, if one is needed, lives in
# ~/.config/secrets.env (untracked) and is sourced from .zshrc.
