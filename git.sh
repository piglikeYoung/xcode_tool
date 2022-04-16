# good experience with git.
# source $MACBOOTSTRAP/git.sh
# eval "$(scmpuff init -s)"

alias ga='git add'
alias gai='git add -i'
alias gan='git_add_new_files'
alias gap='git add -p'
alias gau='git add -u'

alias gb='git branch'

alias gc='git commit'
alias gcb='git checkout -b'
alias gcm='git commit -m'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# 一个 feature 开发完了，已经提交
# 突然发现有几个小问题，修改完后不想生成一个新的 commit
# 下面这条指令就可以将修改直接合并到上一个 commit，并且使用上次提交的信息
alias gcmed='git commit --amend --no-edit'

# 有时你提交过代码之后，发现一个地方改错了，你下次提交时不想保留上一次的记录；
# 或者你上一次的commit message的描述有误，这时候你可以使用接下来的这个命令
alias gcma='git commit --amend'

alias gd='git diff'
alias gdc='git diff HEAD~ HEAD'
alias gdr='git_recursive_diff'
alias gds='git diff --staged'

alias gf='git fetch'
alias gfr='git fetch;git rebase;'
alias ggrep='git grep --break --heading -n'
alias gh='git help --man'
alias gignore='git update-index --assume-unchanged'
alias gl='git log'
alias glp='git log -p'
alias gm='git merge'
alias gco='git checkout'

alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grh='git reset --hard'
alias gri='git rebase -i'
alias gro='git rebase -i --onto'
alias grs='git reset --soft'

alias gst='git stash;git fetch;'
alias gsp='git stash pop'
alias gsr='git_recursive_status'
alias gss='git status --short'

alias cdsubmodule='GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) && [[ -n "$GIT_ROOT" ]] && [[ -f "$GIT_ROOT/.gitmodules" ]] && realpath=$(awk -F= "/path =/ {print substr(\$2, 2)}" "$GIT_ROOT/.gitmodules") && cd "$GIT_ROOT/$realpath"'
alias whyignore='git check-ignore -v'
alias reignore='git rm -r --cached . && git add .'

function gs() {
    if brew ls --versions scmpuff > /dev/null; then
       scmpuff_status
    else
       echo "${YELLOW}You have not install scmpuff, use default git status instead${NC}"
       echo "${YELLOW}Strongly recommend you to install it: brew install scmpuff${NC}"
       echo "${YELLOW}"'And then add this line to you .zshrc: eval "$(scmpuff init -s --aliases=false)"'"${NC}"
       echo ""
       git status
   fi
}

function git_add_new_files() {
    git status --short "$*"|grep '^??'|cut -c 4-|while read -r file;do git add "$file";done
}

function deleteNewFiles() {
    git status --short "$*"|grep '^??'|cut -c 4-|while read -r file;do rm -rf "$file";done
}

function editConfilicts() {
    gvim $(git status --short|grep ^UU|awk '{print $2}')
}

function showConfilictsInRevesion() {
    if [[ -n "$1" ]] ; then
        echo "will show $*"
    else
        echo "you must specify a revision."
        kill -INT $$
    fi
    git status --short|grep ^UU|awk '{print $2}'|while read -r file;
    do
        echo "file:$file in $*"
        git show "$*:$file"
    done
}

function showModifiedFilesInRevesion() {
    if [[ -n "$1" ]] ; then
        echo "will show $*"
    else
        echo "you must specify a revision."
        kill -INT $$
    fi
    git status --short|grep '^ M'|awk '{print $2}'|while read -r file;
    do
        echo "file:$file in $*"
        git show "$*:$file"
    done
}

# copy lxf's scripts.
function __cherry_pick_help() {
    echo "Usage: git_cherry_pick_with_user [-n|--no-date] <commit>..."
}

function __cherry_pick_single_commit() {
    nodate="$1"
    commit="$2"
    committer="$(git log --pretty=fuller -1 $commit|grep 'Commit:'|sed 's/Commit: *//')"
    name="$(echo $committer|sed 's/\(.*\) <.*/\1/')"
    email="$(echo $committer|sed 's/[^<]*//')"
    date="$(git log --pretty=fuller -1 $commit|grep CommitDate|sed 's/CommitDate: *//')"
    echo "Picking $commit $name|$email|$date"
    oldName="$(git config user.name)"
    oldEmail="$(git config user.email)"
    git config user.name "$name"
    git config user.email "$email"
    if [[ "$nodate" == "0" ]]; then
        GIT_AUTHOR_DATE="$date" && GIT_COMMITTER_DATE="$date" && git cherry-pick "$commit"
    else
        git cherry-pick "$commit"
    fi
    git config user.name "$oldName"
    git config user.email "$oldEmail"
}

function git_cherry_pick_with_user() {
    nodate="0"
    case "$1" in
    -h|--help)
        __cherry_pick_help
        ;;
    -n|--no-date)
        nodate="1"
        shift
        ;;
    *)
    ;;
    esac
    if [[ "$1" == "" ]]; then
        __cherry_pick_help
    else
    while [[ $# -gt 0 ]]; do
        commits="$1"
        if [[ -n $(echo "$commits"|grep "\.\.") ]]; then
            for commit in $(git rev-list --reverse "$commits"); do
                __cherry_pick_single_commit $nodate "$commit"
            done
        else # Single commit.
            __cherry_pick_single_commit $nodate "$commits"
        fi
        shift
    done
    fi
}

function git_recursive_status() {
    current=$(git status --short)
    if [[ -n $current ]];
    then
        pwd
        git status --short
    fi
    if [[ -f .gitmodules ]];
    then
        cat .gitmodules|awk -F= '/path = /{print $2}'|while read dir;
        do
            (cd $dir;git_recursive_status)
        done
    fi
}

function git_show_modified_file_names() {
    git ls-files -m "$*"
}

function git_recursive_diff() {
    current=$(git status --short)
    if [[ -n $current ]];
    then
        pwd
        if [[ -n "$*" ]];
        then
            git diff "$*"
        else
            git diff
        fi
    fi
    if [[ -f .gitmodules ]];
    then
        cat .gitmodules|awk -F= '/path = /{print $2}'|while read dir;
        do
            (cd $dir;git_recursive_diff "$*")
        done
    fi
}

function kgitx() {
    local pids=$(ps -A|grep GitX|grep -v grep|awk '{print $1}')
    echo "$pids"|while read -r pid;
    do
       if [[ -n "$pid" ]]; then
            kill -9 $pid
        fi
    done
    gitx "$*"
}

function gnext() {
    git log --reverse --pretty=%H master | grep -A 1 $(git rev-parse HEAD) | tail -n1 | xargs git checkout
}

function gprevious() {
    git checkout HEAD^1
}

# show difference between some commit and its previous branch
# First argument is the commit SHA-1 or HEAD if no argument given. Then second argument is the file name
# Note the diff is reverted so it can be applied to revert the commit
# Usage: gdcr or gdcr <SHA-1> or gdcr <SHA-1> <file_name> or gdcr <SHA-1> <file_name> | git apply
gdcr () {
	commit="$1"
	if [ -z "$1" ]
	then
		commit="HEAD"
	fi
	if [ -z "$2" ]
	then
		command="git diff "$commit" "$commit"~"
		eval $command
	else
		command="git diff "$commit" "$commit"~ "$2""
		eval "$command"
	fi
}

fzf-down() {
  fzf --height 80% "$@" --border
}

_fzf_complete_gbdr() {
    # 把 origin/branch 转换成 branch
    local temp
    temp=$(git branch --remote | awk -F / '{ $1=""; print $0}' OFS="/" | cut -c2- | fzf-down --multi --preview-window right:70% --preview 'git show --color=always origin/{1} | head -'$LINES)
    LBUFFER="$1$temp"
    zle redisplay
}

alias current_branch="git branch --show-current"
gpush() {
    git push origin `current_branch`
}

gpull() {
    git pull origin `current_branch`
}