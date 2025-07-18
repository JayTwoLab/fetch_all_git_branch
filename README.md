# fetch_all_git_branch

- Windows Cmd file to fetch all branches in a git branch.

## Cmd file 

- `fetch.cmd` 

```cmd
:: fetch.cmd
::
:: This script deletes and re-clones specific Git repositories, 
:: and runs git commands (like git pull) inside each one after cloning.

@echo off

:: Please set the values below.
set GIT_REPO_NAME=QPing
set GIT_REPO=https://github.com/JayTwoLab/QPing.git

:: Remove old directory 
if exist %GIT_REPO_NAME% (
	rmdir /s /q %GIT_REPO_NAME%
)	
git clone %GIT_REPO% 
cd %GIT_REPO_NAME%

setlocal enabledelayedexpansion

:: Fetch all remote branches
git fetch --all

:: Exclude origin/HEAD and origin/master from the list
for /f "tokens=*" %%b in ('git branch -r ^| findstr /V "HEAD" ^| findstr /V "origin/master"') do (
    :: Get the full remote branch name (e.g., origin/feature-x)
    set "full_branch=%%b"

    :: Remove 'origin/' prefix
    set "branch_name=%%b"
    set "branch_name=!branch_name:origin/=!"

    echo.
    echo [Checkout and pull] %%b → !branch_name!

    :: Checkout to local branch tracking the remote branch
    git checkout -B !branch_name! %%b

    :: Pull latest changes for the branch
    git pull origin !branch_name!
)

endlocal

:: Checkout master branch
git checkout master
git pull
git status

:: Move to parent directory  
cd
cd ..
cd 
```

## Powershell

- `fetch.ps1` 

```ps1
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
```

## License 

- MIT License
- https://github.com/JayTwoLab/fetch_all_git_branch

