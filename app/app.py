from flask import Flask, jsonify, request
from flask_restful import reqparse, abort, Api, Resource
import pickle
import numpy as np
from predict_boost import predict
app = Flask(__name__)
api = Api(app)

parser = reqparse.RequestParser()
parser.add_argument('query')

model = pickle.load(open('model.pkl', 'rb'))

class MakePrediction(Resource):
    @staticmethod
    def post():
        args = request.get_json()
        pred = predict(args)
        result = jsonify ({"result": pred})
        return result


api.add_resource(PredictBoost, '/predict')

if __name__ == '__main__':
    app.run(debug=True)
