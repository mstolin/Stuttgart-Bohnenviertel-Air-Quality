from flask import Flask
from flask_restful import Api
from resources import AirQuality

app = Flask(__name__)
api = Api(app)

api.add_resource(AirQuality, '/airquality/<city>')

if __name__ == '__main__':
    app.run(port=1337, debug=True)
