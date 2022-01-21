echo "Loading git_toolbox..."

# Delete local git branches which do not have a remote branch
function git_delete_localWithoutRemote {
	git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
}

function git_refresh {
	git fetch --all --prune && git pull origin main
}