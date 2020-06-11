#!/bin/bash

rm -rf repo
mkdir repo

main=$(pwd)
pushd repo

git init --quiet
dvc init -q
git add -A
git commit -am "init"

echo data >> data
dvc add data -q

dvc run -d data -o model -n train_model "cp data model"

cp $main/code.py code.py
dvc run -q -d model -d code.py --plots roc.csv --plots loss_over_time.json --plots confusion.csv -n evaluate "python code.py"

git add -A
git commit -am "first iteration"
git tag v1

cp $main/code1.py code.py
dvc repro -q evaluate

git commit -am "second iteration"
git tag v2

cp $main/code2.py code.py
dvc repro -q evaluate

git commit -am "third iteration"

