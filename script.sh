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
cp $main/params.yaml params.yaml

dvc run -d model -d code.py --plots roc.csv --plots logs.csv --plots confusion.csv -n evaluate --params roc_pow --params conf_success_prob --params loss_pow_denom python code.py 

dvc plots modify confusion.csv --template confusion -x actual -y predicted
dvc plots modify roc.csv -x fpr -y tpr --title "ROC curve" --y-label "True positive rate" --x-label "False postivie rate"

git add -A
git commit -am "first iteration"
git tag v1

echo -e "roc_pow: 0.15
conf_success_prob: 0.65
loss_pow_denom: 6" > params.yaml
dvc repro -q evaluate

git commit -am "second iteration"
git tag v2

echo -e "roc_pow: 0.21
conf_success_prob: 0.8
loss_pow_denom: 8" > params.yaml
dvc repro -q evaluate

git commit -am "third iteration"

dvc plots diff HEAD^ --open
