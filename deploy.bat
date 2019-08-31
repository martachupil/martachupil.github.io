@echo off
set BRANCH=master
set REPO=git@github.com:martachupil/martachupil.github.io.git
set FOLDER=dist

git log --format="%%s (%%H)" -n 1 > .last_commit
set /p COMMIT= < .last_commit
del .last_commit

if EXIST dist (echo Clean... && rmdir /q/s dist)
echo Current commit is %COMMIT%

echo Cloning destination branch...
git clone %REPO% --branch %BRANCH% --single-branch %FOLDER%

echo Clean...
cd %FOLDER%
bash -c "ls -A | grep -v -E '^(.git|.nojekyll|README.md)$' | xargs rm -rf"
cd ..

echo Building site...
copy README.md dist
hugo -d %FOLDER% --gc --minify

echo Deploying site...
cd %FOLDER%
git add .
git commit -m "Deploy changes from commit %COMMIT%"
git push -f origin %BRANCH%

echo Cleanup...
cd ..
rmdir /q/s dist

echo DONE!
