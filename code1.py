import numpy as np
import json
import csv
import random


loss_over_time = []
for i in range(1, 200, 10):
    x = i / 200 * (1 - random.random()*1/7)
    r = 1 - x**(1/8)
    if i == 1:
        r = 1
    loss_over_time.append({"step": i, "loss": r})

with open("loss_over_time.json", "w") as fobj:
    json.dump( loss_over_time, fobj, indent=2, separators=(",", ": "))


# ROC
x = np.linspace(0,1,100)
y = np.power(x, 0.75)


roc = [{"fpr":round(x[i],5), "tpr":round(y[i], 5)} for i in range(len(x))]


with open("roc.csv", "w+") as fobj:
    writer = csv.DictWriter(fobj, fieldnames=["fpr", "tpr"])
    writer.writeheader()
    writer.writerows(roc)

def create_confusion_matrix(success_prob):
    num_per_class = 40
    classes = {"cat", "dog", "bird", "turtle", "dinosaur"}
    result = []
    for c in classes:
        successes = int(num_per_class * success_prob)
        predictions = [c] * successes
        predictions += random.choices(list(classes-{c}), k=num_per_class-successes)
        for p in predictions:
            result.append({"actual":c, "predicted":p})
    with open("confusion.csv", "w+") as fobj:
        writer = csv.DictWriter(fobj, fieldnames=["actual", "predicted"])
        writer.writeheader()
        writer.writerows(result)

create_confusion_matrix(0.7)

def create_feature_importance(factor):
    num_features = 10
    result = {}
    for i in range(num_features):
        result["f{}".format(str(i))]: factor*(random.random() - 0.5)

    with open("feature_importance.csv", "w") as fobj:
        writer = csv.DictWriter(fobj, fieldnames=list(result.keys()))
        writer.writeheader()
        writer.writerows(result)

create_feature_importance(0.6)
