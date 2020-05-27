from flask_restful import Resource


class AirQuality(Resource):
    def get(self, city):
        if (city == 'stuttgart'):
            return {
                'pm10': 10,
                'o3': 10,
                'so2': 10,
                'co': 10,
                'no': 10,
                'luqx': 3
            }
        else:
            return {'pm10': 3, 'o3': 3, 'so2': 3, 'co': 3, 'no': 3, 'luqx': 1}
