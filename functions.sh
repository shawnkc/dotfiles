freespace() {
  df -h / | awk 'NR==2 {print "Free:", $4, "of", $2, "(" $5 " used)"}'
}

gwt() {
    if [ -z "$1" ]; then
        echo "Usage: gwt <branch-name>"
        return 1
    fi
    local worktree_path=$(git-create-worktree.sh "$1")
    if [ $? -eq 0 ] && [ -n "$worktree_path" ]; then
        echo "Switching to: $worktree_path"
        cd "$worktree_path"
    fi
}

ob() {
    if [ -z "$1" ]; then
        echo "Usage: ob <file-name>"
        return 1
    fi
    open-in-obsidian.sh "$1"
}