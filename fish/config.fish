if status is-interactive
    # Commands to run in interactive sessions can go here
end

function vactivate
    source venv/bin/activate.fish
end

function picker
    ~/.local/share/picker/venv/bin/python3.13 ~/.local/share/picker/main.py
end

set -gx EDITOR nvim
set -x PATH $PATH /opt/nvim-linux-x86_64/bin


# Prompt options
set -g theme_display_hostname ssh
set -g theme_display_virtualenv yes
set -g theme_color_scheme nord

set -g theme_display_vagrant no
set -g theme_display_vi yes
set -g theme_display_k8s_context no # yes
set -g theme_display_user yes
set -g theme_display_hostname yes
set -g theme_show_exit_status yes
set -g theme_git_worktree_support no
set -g theme_display_git yes
set -g theme_display_git_dirty yes
set -g theme_display_git_untracked yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_master_branch yes
set -g theme_display_date yes
set -g theme_display_cmd_duration yes
set -g theme_powerline_fonts yes
set -g theme_nerd_fonts yes

