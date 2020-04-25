# Read the fitted model from the file model.pkl
# and define a function that uses the model to
# predict petal width from petal length
import numpy as np
import pickle

model = pickle.load(open('model.pkl', 'rb'))

def predict(args):
  X = np.array(args.get('datos'))
  result = model.predict(X)
  return result
