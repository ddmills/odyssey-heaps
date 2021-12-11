#!/usr/bin/env

git checkout gh-pages
# git reset --hard origin/master

C:\\HaxeToolkit\\haxe\\haxe.exe --connect 6000 compile-js.hxml

# delete everything on the directory
# except the build folder
# find * -maxdepth 0 -name 'build' -prune -o -exec rm -rf '{}' ';'

# move the build folder content
# to the repository root
# mv ./build/* .

# git rm -rf --cache .
git add .
git commit -m "deploy"

git push origin gh-pages --force

git checkout master
