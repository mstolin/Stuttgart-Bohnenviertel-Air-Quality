from flask_restful import Resource, reqparse
from datasources import WorldAirQualityProject

parser = reqparse.RequestParser()
parser.add_argument('lat', type=float)
parser.add_argument('lng', type=float)


class AirQuality(Resource):
    def get(self):
        args = parser.parse_args()

        latitude = args['lat']
        longitude = args['lng']
        if (latitude is None or longitude is None):
            return None

        data_source = WorldAirQualityProject()
        metrics = data_source.request_metrics(latitude, longitude)

        return metrics
