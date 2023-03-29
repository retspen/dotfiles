# ~/.profile: executed by the command interpreter for login shells.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Starship
if command -v "starship" > /dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# PyENV
if command -v "$HOME/.pyenv/bin/pyenv" > /dev/null 2>&1; then
    export PATH="$HOME/.pyenv/bin:$PATH"

    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# Poetry
if command -v "$HOME/.poetry/bin/poetry" > /dev/null 2>&1; then
    export PATH="$HOME/.poetry/bin:$PATH"

fi

# Aliases
alias tmux="tmux attach -t main || tmux new -s main"

# Short prompt
#PS1='\w \$ '
