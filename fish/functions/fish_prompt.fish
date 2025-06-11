function fish_prompt
    set -l base_bg '#282a36'
    set -l mid_bg '#44475a'
    set -l text_color '#f8f8f2'
    set -l git_color '#ffffff'
    set -l venv_color '#50fa7b'

    # Venv
    if set -q VIRTUAL_ENV
        set venv (basename $VIRTUAL_ENV)
        set_color -b $venv_color $base_bg
        echo -n "  $venv "
        set is_venv '1'
    end

    # Git
    if git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
        if test -n "$is_venv"
            set_color -b $base_bg $venv_color
            echo -n ''
        end

        set branch (git symbolic-ref --short HEAD 2>/dev/null)
        set_color -b $base_bg $git_color
        echo -n "  $branch "
        set_color -b $mid_bg $base_bg
        echo -n ''
    else
        if test -n "$is_venv"
            set_color -b $mid_bg $venv_color
            echo -n ''
        end
    end

    set_color -b $mid_bg $text_color
    echo -n ' '(prompt_pwd)' λ '
    
    # End triangle to reset
    set_color -b normal -o $mid_bg
    echo -n ' '
    
    set_color normal
end
