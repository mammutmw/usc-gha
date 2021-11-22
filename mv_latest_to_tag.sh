#!/bin/bash

set -o errexit

tag=${1?"A tag is required"}

git tag -d latest
git tag -a latest $tag -m "Set latest to $tag"
git push origin :latest
git push --tags
