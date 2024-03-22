brew_prefix="$(brew --prefix asdf)"
ASDF_DIR="${brew_prefix}/libexec"
ASDF_COMPLETIONS="${brew_prefix}/etc/bash_completion.d"
unset brew_prefix

# Load command
if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
  . "$ASDF_DIR/asdf.sh"

  # Load completions
  if [[ -f "$ASDF_COMPLETIONS/asdf.bash" ]]; then
    # . "$ASDF_COMPLETIONS/asdf.bash"
    fpath=(
      $ASDF_COMPLETIONS
      $fpath
    )
  fi
fi
