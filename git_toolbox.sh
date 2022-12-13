echo "Loading git_toolbox..."

# Delete local git branches which do not have a remote branch
# interesting additions: https://www.erikschierboom.com/2020/02/17/cleaning-up-local-git-branches-deleted-on-a-remote/
#  gone = ! "git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" {print $1}' | xargs -r git branch -D"

function git_delete_localWithoutRemote {
	git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
}

#  refresh = ! "git fetch --all --prune && git pull origin main"
function git_refresh {
	git fetch --all --prune && git pull origin main
}