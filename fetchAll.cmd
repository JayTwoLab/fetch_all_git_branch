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



