
# get branch
function get_current_branch() {
    GIT_BRANCHES="$(git branch 2>/dev/null)"
    if [ "$?" = "0" ] ; then
        sed -rn "s/^\* (.+)$/\1/p" <<< "$GIT_BRANCHES" # Extract branch with *, indicating it is current branch
    fi
    # No else as if no branch, then no git, so can ignore
    unset GIT_BRANCHES
}

# get changes (won't include new files)
function get_head_git_changes() {
    GIT_SHORTSTAT_DIFF="$(git diff --shortstat HEAD 2>/dev/null)"
    GIT_FILES_CHANGED="$(sed -rn "s/.* ([0-9]+) files? changed.*/\1/p" <<< "$GIT_SHORTSTAT_DIFF")"
    GIT_INSERTIONS="$(sed -rn "s/.* ([0-9]+) insertion.*/\1/p" <<< "$GIT_SHORTSTAT_DIFF")"
    GIT_DELETIONS="$(sed -rn "s/.* ([0-9]+) deletion.*/\1/p" <<< "$GIT_SHORTSTAT_DIFF")"

    echo "${GIT_FILES_CHANGED:-0}/${GIT_INSERTIONS:-0}/${GIT_DELETIONS:-0}"

    unset GIT_SHORTSTAT_DIFF GIT_FILES_CHANGED GIT_INSERTIONS GIT_DELETIONS
}

# aliases
alias gs="git status"
alias gp="git push"
alias gpo="gp origin"
alias gpoc='gpo "$(get_current_branch)"'
alias gcm="git commit -m"
