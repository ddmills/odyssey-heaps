#!/usr/bin/env

git checkout gh-pages

c:/HaxeToolkit/haxe/haxe.exe ./compile-js.hxml

find * -maxdepth 0 -name 'build' -prune -o -exec rm -rf '{}' ';'

mv ./build/js/* .

git rm -rf --cache .
git add .
git commit -m "deploy"

git push origin gh-pages --force

git checkout master
