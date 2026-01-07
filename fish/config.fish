if status is-interactive
    # Commands to run in interactive sessions can go here
end

function vactivate
    set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
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

set -U fish_greeting "🐟"

# GitHub CI status - async background fetch
set -g __ci_status_fetch_time 0

function __get_ci_status
    # Only run in git repos
    if not git rev-parse --git-dir >/dev/null 2>&1
        return
    end

    set -l branch (git branch --show-current 2>/dev/null)
    if test -z "$branch"
        return
    end

    set -l cache_file ~/.cache/fish_ci_status
    mkdir -p ~/.cache

    # Read and display cached value
    if test -f $cache_file
        set -l cached (string split ":" < $cache_file)
        if test "$cached[1]" = "$branch" -a -n "$cached[2]"
            set_color $cached[3]
            echo -n $cached[2]
            set_color white  # restore git_color
        end
    end

    # Refresh in background every 60 seconds
    set -l now (date +%s)
    if test (math $now - $__ci_status_fetch_time) -ge 60
        set -g __ci_status_fetch_time $now
        fish -c "
            set -l result (gh run list --branch $branch --limit 1 --json conclusion,status --jq '.[0] | \"\(.conclusion // .status)\"' 2>/dev/null)
            set -l icon ''
            switch \$result
                case success; set icon '✓:green'
                case failure; set icon '✗:red'
                case cancelled; set icon '⊘:yellow'
                case in_progress queued; set icon '⋯:yellow'
            end
            echo '$branch:'\$icon > ~/.cache/fish_ci_status
        " &
        disown
    end
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
