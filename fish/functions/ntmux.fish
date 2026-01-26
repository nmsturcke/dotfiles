function ntmux
    set -l target_dir (realpath $argv[1] 2>/dev/null; or echo $PWD)
    set -l session_name (basename $target_dir | string replace -a '.' '_')

    tmux new-session -d -s $session_name -c $target_dir
    tmux split-window -h -c $target_dir
    tmux split-window -v -c $target_dir
    tmux select-pane -t 0
    tmux attach-session -t $session_name
end
