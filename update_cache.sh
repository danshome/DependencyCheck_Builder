#!/bin/bash

git checkout main
git pull
git checkout gh-pages
git pull origin gh-pages

curl https://github.com/jeremylong/open-vulnerability-cli/releases/download/v7.2.2/vulnz-7.2.2.jar -s -L -o vulnz.jar
git reset --soft HEAD~1
ls -la .

echo "login to 1password"
eval $(op signin)

op run --java -jar vulnz.jar cve --cache --directory ./nvd_cache  --threads=4 --maxRetry=40 --debug --delay=8000
rm vulnz.jar
git status
cat nvd_cache/cache.properties
git add ./nvd_cache/
git commit -am 'chore: update'
git push origin gh-pages --force

git checkout main
