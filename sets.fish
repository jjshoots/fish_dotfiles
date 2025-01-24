# fish settings
set -g fish_term24bit 0
set -g -x fish_greeting ''

# disable pip outside of venv
set -gx PIP_REQUIRE_VIRTUALENV true

# Homebrew path
if test -d /opt/homebrew/bin
    set -gx PATH /opt/homebrew/bin $PATH
end

# python runtime paths
if test -n "$VIRTUAL_ENV"
    set -gx PATH "$VIRTUAL_ENV/bin" $PATH
end

# rust paths
if test -e $HOME/.cargo/bin
    set -gx PATH $PATH $HOME/.cargo/bin
end

# jekyll gems
if test -e $HOME/System/gems
    set -gx GEM_HOME $HOME/System/gems
    set -gx PATH $PATH $HOME/System/gems/bin
end
