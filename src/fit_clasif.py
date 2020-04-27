import numpy as np
import pandas as pd
import matplotlib.pyplot as plot

from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score, confusion_matrix, accuracy_score
from xgboost import XGBClassifier
import pickle
import cdsw

# Split train-test
data = pd.read_csv('Bank_Loan_clean.csv')
train_set, test_set = train_test_split(data.drop(['Unnamed: 0','ID'], axis=1), test_size=0.8 , random_state=100)
y_train = train_set.pop('Personal Loan')
y_test = test_set.pop('Personal Loan')         

scaler = MinMaxScaler()
x_train = scaler.fit_transform(train_set)
x_test = scaler.transform(test_set)

# modelo
xgb_clf = XGBClassifier()
xgb_clf.fit(x_train, y_train.values)

pred = xgb_clf.predict(x_test)
# calculamos precisión y auc
confusion_matrix(y_test, pred)

auc = roc_auc_score(y_test, pred)
acc = accuracy_score(y_test, pred)

# Set metrics to track
#cdsw.track_metric('acc', acc)
#cdsw.track_metric('auc', auc)


# Output
filename = 'model.pkl'
with open(filename, 'wb') as model_file:
  pickle.dump(xgb_clf, model_file)
#cdsw.track_file(filename)