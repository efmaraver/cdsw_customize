from flask import Flask, jsonify, request
from flask_restful import reqparse, abort, Api, Resource
import pickle
import numpy as np
import json
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
        res = map(int, pred)
        result = jsonify (json.dumps({"result": list(res)}))
        return result

api.add_resource(MakePrediction, '/predict')
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
