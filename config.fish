# fish settings
set -g fish_term24bit 0
set -g -x fish_greeting ''

# disable pip outside of venv
set -gx PIP_REQUIRE_VIRTUALENV true

# set install location for gems
set -gx GEM_HOME $HOME/System/gems
set -gx PATH $HOME/System/gems/bin $PATH

# STOP USING RM
alias rm='echo "This is not the command you are looking for."; false'
alias tp=trash-put

# change ls to exa
alias ls=exa\ --icons

# tmux
alias ta=tmux\ attach\ -t
alias tk=tmux\ kill-session\ -t

# python venv sourcing
alias sv=source\ venv/bin/activate.fish
alias dv=deactivate

# check for venv to source when nvim
function vvim -d "Call neovim but also check if venv exists to source."
  # if a venv exists
  if test -e ./venv/bin/activate.fish
    # check if we have another venv sourced, if we do then deactivate
    if set -q VIRTUAL_ENV
      deactivate
    end

    # source the current venv, nvim, cleanup
    source venv/bin/activate.fish
    nvim $argv
    deactivate
  else
    nvim $argv
  end
end

# add some things to path
if test -e ~/.local/bin
  set PATH $PATH ~/.local/bin
end
if test -e ~/.cargo/bin
  set PATH $PATH ~/.cargo/bin
end
