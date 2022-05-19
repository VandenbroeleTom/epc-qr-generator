#! /usr/bin/env sh

set -ex

REPOSITORY=$(git config --get remote.origin.url)
BASE_HREF="/epc-qr-generator/"

flutter clean
flutter build web --release --base-href $BASE_HREF

cd build/web

git init
git add .
git commit -m "DEPLOY"
git push -f $REPOSITORY master:gh-pages

cd -
