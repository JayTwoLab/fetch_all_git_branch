# fetchAll.ps1
# This script clones a list of Git repositories after deleting existing folders if they exist,
# and then runs 'git pull' inside each cloned repository to ensure it's up to date.

# Save current working directory
$WORKDIR = Get-Location

$GIT_NAME = "QPing"
$GIT_REPO = "https://github.com/JayTwoLab/QPing.git"

if (Test-Path $GIT_NAME) {
	Remove-Item -Recurse -Force $GIT_NAME
}

git clone $GIT_REPO
cd $GIT_NAME

git fetch --all

# Get list of remote branches, excluding HEAD and origin/master
$branches = git branch -r | Where-Object { $_ -notmatch 'HEAD' -and $_ -notmatch 'origin/master' }

foreach ($line in $branches) {
    $full_branch = $line.Trim()                            # Remove leading/trailing spaces
    $branch_name = $full_branch -replace '^origin/', ''    # Remove 'origin/' prefix

    Write-Host ""
    Write-Host "[Checkout and pull] $full_branch → $branch_name"

    git checkout -B $branch_name $full_branch              # Create or reset local branch
    git pull origin $branch_name                           # Pull latest changes from origin
}

git checkout master
git pull

cd ..
