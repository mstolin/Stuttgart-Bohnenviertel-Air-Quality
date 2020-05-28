from requests_futures.sessions import FuturesSession
from datasources.DataSource import DataSource
from os import environ


class WorldAirQualityProject(DataSource):
    def __init__(self):
        self._api_endpoint_url = 'https://api.waqi.info/feed'

    def _get_api_url(self, lat, lng):
        token = environ.get('AQODP_API_TOKEN')
        if (token is None):
            raise TypeError

        return f'{self._api_endpoint_url}/geo:{lat};{lng}/?token={token}'

    def _map_json_response(self, response):
        quality_data = response['data']['iaqi']
        pm10 = quality_data['pm10']['v']
        o3 = quality_data['o3']['v']
        no2 = quality_data['no2']['v']

        return {'pm10': pm10, 'o3': o3, 'no2': no2}

    def request_metrics(self, lat, lng):
        session = FuturesSession()
        api_future = session.get(self._get_api_url(lat, lng))
        api_json_response = api_future.result().json()

        return self._map_json_response(api_json_response)
