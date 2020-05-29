from flask import Flask
from flask_restful import Api
from flask_cors import CORS
from models.ApiResources import AirQuality

app = Flask(__name__)
api = Api(app)
CORS(app)  # Plz dont do this in production

api.add_resource(AirQuality, '/airquality')

if __name__ == '__main__':
    app.run(port=1337, debug=True)
