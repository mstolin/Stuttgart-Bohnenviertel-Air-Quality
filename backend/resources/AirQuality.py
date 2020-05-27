from flask_restful import Resource, reqparse

parser = reqparse.RequestParser()
parser.add_argument('lat', type=float)
parser.add_argument('long', type=float)


class AirQuality(Resource):
    def get(self, city):
        args = parser.parse_args()
        return args
