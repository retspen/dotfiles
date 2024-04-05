# ~/.bash_profile

# Starship
if command -v "starship" > /dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# Aliases
alias tmux="tmux attach -t main || tmux new -s main"
