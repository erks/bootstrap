# deps:
if [ -f "$SCRIPT_DIR/config.sh" ]; then
    source "$SCRIPT_DIR/config.sh"
    [ -n "$GIT_NAME" ] && git config --global user.name "$GIT_NAME"
    [ -n "$GIT_EMAIL" ] && git config --global user.email "$GIT_EMAIL"
fi
